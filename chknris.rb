$version = "1.0"


def print_help
    puts "Chuck Norris quotes cli app"
    print "version: "
    print_version()

    puts "\nUSAGE"
    puts "\t-h, --help\tprints cli help"
    puts "\t-v, --version\tprints version information"
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
    else
        bad_arguments()
    end
end


if ARGV.length == 0
    bad_arguments()
end


parse_args()