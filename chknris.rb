require 'net/http'
require 'json'

$version = "1.0"


class ChuckFailedUs < StandardError; end


def print_help
    puts "Chuck Norris quotes cli app"
    print "version: "
    print_version()

    puts "\nUSAGE"
    puts "\tchknris [FLAGS]"

    puts "\nFLAGS"
    puts "\t-h, --help\tprints cli help"
    puts "\t-v, --version\tprints version information"
    puts "\t-l, --list\tlists chuck norris quotes categories"
end


def print_version
    puts "v#{$version}"
end


def bad_arguments
    print_help()
    exit 1
end


def parse_args
    case ARGV[0]
    when "-h", "--help"
        print_help()
    when "-v", "--version"
        print_version()
    when "-l", "--list"
        begin
            for category in get_quote_categories()
                puts category
            end
        rescue ChuckFailedUs
            STDERR.puts "Failed to fetch quote categories list"
            exit 2
        end
    else
        STDERR.puts "Invalid flag \"#{ARGV[0]}\"\n\n"
        bad_arguments()
    end
end


def get_random_quote
    res = Net::HTTP.get_response(URI('https://api.chucknorris.io/jokes/random'))
    if res.code != "200"
        raise ChuckFailedUs
    end
    JSON.parse(res.body)["value"]
end


def get_quote_categories
    res = Net::HTTP.get_response(URI('https://api.chucknorris.io/jokes/categories'))
    if res.code != "200"
        raise ChuckFailedUs
    end
    JSON.parse(res.body)
end


if ARGV.length == 0
    begin
        puts get_random_quote()
    rescue ChuckFailedUs
        STDERR.puts "Failed to fetch quote"
        exit 2
    end
else
    parse_args()
end



