import argparse

from linkarchivetools.dbfilter import DbFilter
from linkarchivetools.db2json import Db2JSON
from linkarchivetools.dbanalyzer import DbAnalyzer


def parse():
    parser = argparse.ArgumentParser(description="Data analyzer program")
    parser.add_argument("--db", help="DB to be scanned")
    parser.add_argument("--output-dir", help="Directory to be created")
    parser.add_argument("--file-names", help="File names")
    parser.add_argument("--bookmarked", action="store_true", help="export bookmarks")
    parser.add_argument("--votes", action="store_true", help="export if votes is > 0")
    parser.add_argument("--redundant", action="store_true", help="entries are redundant")
    parser.add_argument("-v", "--verbosity", help="Verbosity level")
    
    args = parser.parse_args()

    return parser, args


def main():
    output_fie = "internet.db"

    parser, args = parse()
    if not args.db:
        print("Please specify database")
        return

    #analyzer = DbAnalyzer(input_db = args.db)
    #analyzer.print_summary()

    print("Filtering")
    filter = DbFilter(input_db=args.db,output_db=output_fie)
    if args.votes:
        filter.filter_votes()
    if args.bookmarked:
        filter.filter_bookmarked()
    if args.redundant:
        filter.filter_redundant()
    filter.close()
    print("Filtering DONE")

main()
