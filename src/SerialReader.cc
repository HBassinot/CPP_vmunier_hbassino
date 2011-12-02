/** 
 * \file SerialReader.cc
 * \author Vincent MUNIER, Hervé BASSINOT
 */

#include "SerialReader.hh"
#include <iostream>
#include <typeinfo>

using namespace std;


SerialReader::SerialReader(ifstream& infile) : m_infile(infile) { 
    if (!m_infile.is_open())
        throw string("Error opening file");
}

SerialReader::~SerialReader() {
    m_infile.close();
} 

