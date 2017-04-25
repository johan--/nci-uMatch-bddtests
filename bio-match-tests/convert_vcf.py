#!/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python

import os
import sys
import argparse
import textwrap
import logging

from vcf import Vcf, VcfConverter, __version__, supported_ir_vcf_versions


def main(args_text=None):
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(
            '''
            Oncomine(R) VCF Converter
            -----------------------
            Converts VCF files output by Ion Reporter(TM) sequencing software
            into a TSV file broken out by alternate alleles.
            '''
        )
    )

    parser.add_argument(
        '--input', '-i', required=True, help='VCF file to convert', metavar='<VCF file>', dest='vcf_file_name')

    parser.add_argument('--output', '-o', help='TSV file to write', metavar='<TSV file>', dest='tsv_file_name')

    parser.add_argument(
        '--column-list-file', '-c', help='TXT file with one field per line to include in output file',
        metavar='<column list file>', dest='column_file_name'
    )

    parser.add_argument(
        '--force', '-f', help='Force output to overwrite previous output, if any exists', action='store_true',
        dest='force_output_overwrite'
    )

    parser.add_argument(
        '--all-genes', '-a', help='Keep annotations for all genes in a record\'s FUNC block. Default is to keep '
                                  'only Oncomine genes', action='store_true', dest='keep_all_genes'
    )

    parser.add_argument(
        '--all-cnvs', help='Keep all CNV records in the output. Default is to remove CNVs with no gene associated',
        action='store_true', dest='keep_all_cnvs'
    )

    parser.add_argument(
        '--meta', '-m',
        help='Include metadata fields from the VCF file. Optionally specify a comma-separated list of metadata fields '
             'to include. If no list is provided, the following fields will be included: sampleGender, '
             'sampleDiseaseType, CellularityAsAFractionBetween0-1, TotalMappedFusionPanelReads, mapd.',
        metavar='<list of metadata fields>', nargs='?', dest='meta', default=False
    )

    parser.add_argument('--version', '-v', action='version', version='%(prog)s {version}'.format(version=__version__))

    # This option is used only by automated unit tests
    parser.add_argument(
        '--sanitize', '-s', help='Forcefully Sanitize VCF Data', action='store_true',
        dest='force_sanitize'
    )

    args = parser.parse_args(args_text.split() if args_text is not None else None)
    set_up_logger()
    logging.info("================Starting the process of VCF Conversion================")
    # Check for unwanted characters in the vcf file
    status = True
    if args.force_sanitize:
        status = check_vcf_file_data(args.vcf_file_name)
    if not status:
        sys.exit("You chose to terminate VCF file processing")
    vcf_object = Vcf.create_from_vcf_file(args.vcf_file_name)
    converter = VcfConverter()

    output_file_name = args.tsv_file_name if args.tsv_file_name else args.vcf_file_name.replace('.vcf', '.tsv')

    if os.path.exists(output_file_name) and not args.force_output_overwrite:
        sys.exit('A file or folder with the name \'{tsv}\' already exists. Use --force to overwrite.'.format(
            tsv=output_file_name))
    else:
        columns_to_include = []
        if args.column_file_name:
            if os.path.isfile(args.column_file_name):
                with open(args.column_file_name, 'r') as column_file:
                    columns_to_include = [column.rstrip('\r\n') for column in column_file.readlines()]
            else:
                sys.exit('The column list file \'{file}\' does not exist!'.format(file=args.column_file_name))
        allele_records = converter.convert(
            vcf_object, keep_all_genes=args.keep_all_genes, keep_all_cnvs=args.keep_all_cnvs)

        if vcf_object.ir_vcf_version not in supported_ir_vcf_versions:
            sys.exit('Oncomine(R) VCF Converter expects an IR VCF with IonReporterExportVersion of {vcf_version}.  '
                     'Input VCF IonReporterExportVersion: {actual_version}.'
                     .format(vcf_version=' or '.join(supported_ir_vcf_versions),
                             actual_version=vcf_object.ir_vcf_version))

        meta_fields = None
        if args.meta is not None:
            meta_fields = [f.strip() for f in args.meta.split(',')] if args.meta else []

        converter.write_to_file(
            output_file_name, allele_records, vcf_object.metadata_raw, meta_fields, columns_to_include)
    logging.info("================End of the process of VCF Conversion================")
    # Close the log File
    close_logger_handler()


def check_vcf_file_data(vcf_file_name):
    """
    User interaction to forcefully clean data or terminate the processing
    :param vcf_file_name:
    :return:boolean
    """
    if not os.path.isfile(vcf_file_name):
        sys.exit('The VCF file \'{vcf}\' does not exist!'.format(vcf=vcf_file_name))
    with open(vcf_file_name, 'r') as vcf_file:
        lines = vcf_file.readlines()
        if any(line.find('\r') for line in lines):
            logging.warn("There are some unexpected characters in VCF File")
            user_input = raw_input("Press 'Y' to forcefully clean data.\nOr press 'N' to exit. "
                                   "(Help: Use dos2unix to clean data)\n")
            if user_input == 'Y':
                return True
    return False


def set_up_logger():
    """
    Setup a console logger
    """
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                        format='%(asctime)s %(levelname)-8s %(message)s',
                        datefmt='%m-%d-%Y %H:%M'
                        )


def close_logger_handler():
    """
    Close the stream for console logging
    """
    handlers = logging.getLogger('').handlers[:]
    for handler in handlers:
        handler.close()
        logging.getLogger('').removeHandler(handler)


if __name__ == '__main__':
    main()
