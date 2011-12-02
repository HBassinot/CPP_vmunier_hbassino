/** 
 * \file SerialWriter.hh
 * \author Vincent MUNIER, Hervé BASSINOT
 */

#ifndef H_SERIALWRITER_H
#define H_SERIALWRITER_H

#include <fstream>
#include <typeinfo>

using namespace std;

class SerialWriter
{
public:
    SerialWriter(ofstream& outfile);
    
    template <typename T>
    void write(const T& val) {
        m_outfile << typeid(val).name();
        m_outfile << " ";
        m_outfile << val;
	m_outfile << " ";
    }

    virtual ~SerialWriter() {
        m_outfile.close();
    }

private:
    ofstream& m_outfile;
};

#endif /* H_SERIALWRITER_H */
