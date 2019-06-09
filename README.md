# Simple and fast CSV reader written in C

## Description
Simple and fast library for fast reading of large CSV files using memory-mapped files.
Purpose of this project was to create fast CSV (comma separated values) reader implementation in C with very simple interface using memory-mapped files.

## Features
* Simple C interface
* Very large CSV file support - GBs, TBs
* Using memory mapped files
* Supports UNIX and Windows platforms
* UTF-8 support
* Supports both Windows CRLF "\r\n" and Unix LF "\n" sequences
* Supports newlines "\n" in CSV columns
* Spaces are preserved (e.g "one, two" -> {"one", " two"})

## How to compile
You can add ```csv.c``` file to your project or you can use Makefile provided.
To compile csv library on Linux with GNU Make:

* run ```make all``` from project root to compile all targets and test application

## How to use (trivial example)
Error handing ommited for brevity

```C++
char* row;
int cols = 0;
CsvHandle handle = CsvOpen("csvfile.csv");

while (row = CsvReadNextRow(handle))
{
    /* row = CSV row string */
    const char* col;
    while (col = CsvReadNextCol(row, handle))
        cols++;  /* col = CSV col string */
}

printf("Number of cols %i", cols);
```

## Public API functions

If you want to read classic CSV files, you can follow this pipeline:
1. ```CsvOpen()``` to open CSV file
2. ```CsvReadNextRow()``` to read single CSV line
3. ```CsvReadNextCol()``` to read single CSV column
4. ```CsvClose()``` to close opened CSV handle

### ```CsvOpen(const char* filepath)```
Opens a CSV file.
#### Paramters:
* filepath, (```const char*```): path to a CSV file
#### Return value:
```CsvHandle```: handle to a CSV file on success, NULL otherwise

### ```CsvOpen2(const char* filepath, char delim, char quote, char escape)```
Opens a CSV file. You can specify custom CSV delimeter, quote and escape char.
#### Parameters:
* filepath, (```const char*```): path to a CSV file
* delim (```char```): custom CSV delimeter ASCII character (default ',')
* quote (```char```): custom CSV quote ASCII character (default '"')
* escape (```char```): custom CSV escape ASCII character (default '\\')
#### Return value:
```CsvHandle```: handle to a CSV file on success, NULL otherwise

### ```CsvClose(CsvHandle handle)```
Releases all resources allocated.
#### Parameters:
* handle (```CsvHandle```): handle opened by CsvOpen() or CsvOpen2()

### ```CsvReadNextRow(CsvHandle handle)```
Returns pointer to new line (UTF-8 zero terminated string) or NULL.
#### Parameters:
* handle (```CsvHandle```): handle opened by CsvOpen() or CsvOpen2()
#### Return value:
```char*```: zero terminated string on success, NULL on EOF or error.

### ```CsvReadNextCol(CsvHandle handle, char* row)```
Returns pointer to column (UTF-8 zero terminated string) or NULL
#### Parameters:
* handle (```CsvHandle```): handle opened by CsvOpen() or CsvOpen2()
#### Return value
```const char*```: zero terminated string on success, NULL on EOL or error.

## License
MIT (see LICENSE.txt)
