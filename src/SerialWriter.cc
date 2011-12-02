/** 
 * \file SerialWriter.cc
 * \author Vincent MUNIER, Hervé BASSINOT
 */

#include "SerialWriter.hh"
#include <typeinfo>

SerialWriter::SerialWriter(ofstream& outfile) : m_outfile(outfile) {
    if (!m_outfile.is_open())
        throw string("Error opening file");
}
