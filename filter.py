import argparse

from linkarchivetools.dbfilter import DbFilter
from linkarchivetools.db2json import Db2JSON
from linkarchivetools.dbanalyzer import DbAnalyzer
from linkarchivetools.utils.reflected import ReflectedTable, ReflectedGenericTable
from linkarchivetools.model import DbConnection


def parse():
    parser = argparse.ArgumentParser(description="Data analyzer program")
    parser.add_argument("--db", help="DB to be scanned")
    parser.add_argument("--output-dir", help="Directory to be created")
    parser.add_argument("--filter", action="store_true", help="entries are redundant")
    parser.add_argument("--cleanup", action="store_true", help="entries are redundant")
    parser.add_argument("-v", "--verbosity", help="Verbosity level")
    
    args = parser.parse_args()

    return parser, args


def main():
    output_file = "internet.db"

    parser, args = parse()
    if not args.db:
        print("Please specify database")
        return

    #analyzer = DbAnalyzer(input_db = args.db)
    #analyzer.print_summary()

    if args.filter:
        print("Filtering")
        filter = DbFilter(input_db=args.db,output_db=output_file)
        filter.filter_redundant()
        filter.close()
        print("Filtering DONE")

    if args.cleanup:
        connection = DbConnection(output_file)

        tables = [
                  "apikeys",
                  "applogging",
                  "backgroundjob",
                  "backgroundjobhistory",
                  "blockentry",
                  "blockentrylist",
                  "browser",
                  "credentials",
                  "dataexport",
                  "domains",
                  "entryrules",
                  "gateway",
                  "keywords",
                  "modelfiles",
                  "readlater",
                  "sourcecategories",
                  "sourcesubcategories",
                  "sourceoperationaldata",
                  "userbookmarks",
                  "usercomments",
                  "usertags",
                  "uservotes",
                  ]

        for table_name in tables:
            table = ReflectedGenericTable(engine=connection.engine, connection=connection.connection, table_name=table_name)
            table.truncate()

        # TODO make cleanup

        table = ReflectedTable(engine=connection.engine, connection=connection.connection)
        table.vacuum()

main()
