import argparse

from linkarchivetools.dbfilter import DbFilter, parse
from linkarchivetools.db2json import Db2JSON


def main():
    parser, args = parse()
    if not args.db:
        print("Please specify database")
        return

    print("Filtering")
    filter = DbFilter(db=args.db)
    filter.delete_entries_redundant()
    filter.truncate_user_tables()
    filter.truncate_dynamic_data()
    filter.truncate_tables({"domains"})
    filter.obfuscate()
    filter.close()
    print("Filtering DONE")

main()
