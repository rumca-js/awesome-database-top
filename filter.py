import argparse

from linkarchivetools.dbfilter import DbFilter, parse
from linkarchivetools.db2json import Db2JSON
from linkarchivetools.dbanalyzer import DbAnalyzer
from linkarchivetools.utils.reflected import ReflectedTable, ReflectedGenericTable
from linkarchivetools.model import DbConnection


def main():
    output_file = "internet.db"

    parser, args = parse()
    if not args.db:
        print("Please specify database")
        return

    #analyzer = DbAnalyzer(input_db = args.db)
    #analyzer.print_summary()

    print("Filtering")
    filter = DbFilter(input_db=args.db,output_db=output_file)
    filter.filter_redundant()
    filter.trunceate_no_users()
    filter.close()
    print("Filtering DONE")

    connection = DbConnection(output_file)
    table = ReflectedTable(engine=connection.engine, connection=connection.connection)
    table.vacuum()
    table.close()
    connection.close()

main()
