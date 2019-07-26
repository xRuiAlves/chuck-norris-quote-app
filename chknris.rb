require "net/http"
require "json"

$version = "1.0"


class ChuckFailedUs < StandardError; end
class ChuckIsOblivious < StandardError; end


def print_help
    puts "Chuck Norris quotes app"
    print "version: "
    print_version()

    puts "\nUSAGE"
    puts "\tchknris [FLAGS]"

    puts "\nFLAGS"
    puts "\t-h, --help\tprints help"
    puts "\t-v, --version\tprints version information"
    puts "\t-l, --list\tlists chuck norris quotes categories"
    puts "\t-c, --category\tspecify chuck norris quote category"
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
    when "-c", "--category"
        category = ARGV[1]
        if !category
            STDERR.puts "Quote category missing!"
            exit 1
        end
        begin
            puts get_quote(category)
        rescue ChuckIsOblivious
            STDERR.puts "Quote category is invalid.\n\n"
            STDERR.puts "Use 'chrnris --list' to obtain the full list of valid quote categories."
            exit 1
        rescue ChuckFailedUs
            STDERR.puts "Failed to fetch quote"
            exit 2
        end
    else
        STDERR.puts "Invalid flag \"#{ARGV[0]}\"\n\n"
        bad_arguments()
    end
end


def get_random_quote
    res = Net::HTTP.get_response(URI("https://api.chucknorris.io/jokes/random"))
    if res.code != "200"
        raise ChuckFailedUs
    end
    JSON.parse(res.body)["value"]
end


def get_quote_categories
    res = Net::HTTP.get_response(URI("https://api.chucknorris.io/jokes/categories"))
    if res.code != "200"
        raise ChuckFailedUs
    end
    JSON.parse(res.body)
end


def get_quote(category)
    res = Net::HTTP.get_response(URI("https://api.chucknorris.io/jokes/random?category=#{category}"))
    if res.code == "404"
        raise ChuckIsOblivious
    elsif res.code != "200"
        raise ChuckFailedUs
    end
    JSON.parse(res.body)["value"]
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



