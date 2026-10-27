# ST_BarcodeMap
This program can map barcode of stereomics-seq to stereomics-chip

## Container (Docker / Singularity)

Pre-built container images are automatically published via GitHub Actions to GitHub Container Registry (GHCR):

```bash
docker pull ghcr.io/biocorecrg/st_barcodemap:latest
```

### Running with Docker

```bash
docker run --rm -v "$(pwd)":/data -w /data ghcr.io/biocorecrg/st_barcodemap:latest \
  --in mask.h5 --in1 read1.fq.gz --in2 read2.fq.gz --out combine_read.fq.gz --mismatch 1 --thread 2
```

### Running with Apptainer / Singularity

```bash
singularity exec docker://ghcr.io/biocorecrg/st_barcodemap:latest ST_BarcodeMap \
  --in mask.h5 --in1 read1.fq.gz --in2 read2.fq.gz --out combine_read.fq.gz --mismatch 1 --thread 2
```

### Building the Docker image locally

```bash
docker build -t st_barcodemap:latest .
```

## Compile locally
### Platform & Environment
* linux
* gcc-8.2.0 or newer

## Prerequisites
| Package       | Version  | Description                                                |
| ------------- | -------- | ---------------------------------------------------------- |
| boost         | >=1.73.0 | serialize hashmap                                          |
| zlib          | >=1.2.11 | file compressing and decompressing                         |
| hdf5          | >=1.10.7 | hdf5 format mask file read                                 |

## make the runnable program
```bash
# On Debian/Ubuntu:
# sudo apt-get install -y build-essential libboost-serialization-dev libhdf5-dev zlib1g-dev

cd ST_BarcodeMap
make
sudo make install
```

## Run
### Usage
```
usage: ST_BarcodeMap-0.0.1 --in=string --out=string [options] ... 
options:
  -i, --in                        mask file of stereomics chip or input barcode_list file (string)
  -I, --in1                       the second sequencing fastq file path of read1 (string [=])
      --in2                       the second sequencing fastq file path of read2 (string [=])
      --barcodeReadsCount         the mapped barcode list file with reads count per barcode. (string [=])
  -O, --out                       output file prefix or fastq output file of read1 (string)
      --out2                      fastq output file of read2 (string [=])
      --report                    logging file path. (string [=])
      --PEout                     if this option was given, PE reads with barcode tag will be writen
      --protein                   if this option was given, this program will process protein barcode sequence in the read2.
      --proteinBarcodeList        if option --protein was given, this option os requested (string [=])
  -z, --compression               compression level for gzip output (1 ~ 9). 1 is fastest, 9 is smallest, default is 4. (int [=4])
      --unmappedOut               output file path for barcode unmapped reads of read1, if this path isn't given, discard the reads. (string [=])
      --unmappedOut2              output file path for barcode unmapped reads of read2, if this path isn't given, discard the reads. (string [=])
  -l, --barcodeLen                barcode length, default is 25 (unsigned int [=25])
      --barcodeStart              barcode start position (int [=0])
      --umiRead                   read1 or read2 contains the umi sequence. (int [=1])
      --barcodeRead               read1 or read2 contains the barcode sequence. (int [=1])
      --umiStart                  umi start position. if the start postion is negative number, no umi sequence will be found (int [=25])
      --umiLen                    umi length. (int [=10])
      --fixedSequence             fixed sequence in read1 that will be filtered. (string [=])
      --fixedStart                fixed sequence start position can by specied. (int [=-1])
      --barcodeSegment            barcode segment for every position on the stereo-chip. (int [=1])
      --fixedSequenceFile         file contianing the fixed sequences and the start position, one sequence per line in the format: TGCCTCTCAG   -1. when position less than 0, means wouldn't specified (string [=])
      --mapSize                   bucket size of the new unordered_map. (long [=0])
      --mismatch                  max mismatch is allowed for barcode overlap find. (int [=0])
      --proteinBarcodeMismatch    max mismatch is allowed for protein barcode overlap find. (int [=1])
      --proteinBarcodeStart       protein barcode start position. (int [=0])
      --proteinBarcodeLen         protein barcode length. (int [=15])
      --action                    chose one action you want to run [map_barcode_to_slide = 1, merge_barcode_list = 2, mask_format_change = 3, mask_merge = 4]. (int [=1])
  -w, --thread                    number of thread that will be used to run. (int [=2])
  -V, --verbose                   output verbose log information (i.e. when every 1M reads are processed).
  -?, --help                      print this message
  ```
  ### run example
  #### barcode mapping 
  ```
  ST_BarcodeMap-0.0.1 --in mask.h5 --in1 read1.fq.gz --in2 read2.fq.gz --out combine_read.fq.gz --mismatch 1 --thread 2
  ```
  #### mask format change
  ```
  #transfer mask file in binary format into text format

  ST_BarcodeMap-0.0.1 --in mask.bin --out mask.txt --action 3

  #transfer mask file in hdf5 format into text format

  ST_BarcodeMap-0.0.1 --in mask.h5 --out mask.txt --action 3
  ```
