#include <iostream>
#include <typeinfo>
#include <sstream>

#include "SerialWriter.hh"
#include "SerialReader.hh"
#include "Serialize.hh"

using namespace std;

static const char* serialFileName("serialized.txt");

void serial_read();
void serial_write();

int main(void) {
    try {
	serial_write();
	serial_read();
    }
    catch(string const& error) {
        cerr << error << endl;
    }
    return 0;
}

void serial_read() {
        ifstream infile;
        infile.open(serialFileName);
    
        SerialReader sr(infile);

        int j = 0;
        sr.read<int>(j);
        cout << "j = " << j << endl;

        double *d = sr.read_alloc<double>();
        cout << "d = " << (*d) << endl;

        string str;
        sr.read<string>(str);
        cout << "str = " << str << endl;
}

void serial_write() {
    ofstream outfile;
    outfile.open(serialFileName);

    SerialWriter sw(outfile);
    sw.write(5);

    double d(15.8);
    sw.write(d);
        
    string str("super");
    sw.write(str);
}
