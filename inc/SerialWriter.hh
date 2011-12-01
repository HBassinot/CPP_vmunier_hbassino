/** 
 * \file SerialWriter.hh
 * \author Vincent MUNIER
 */


#ifndef H_SERIALWRITER_H
#define H_SERIALWRITER_H

#include <fstream>
using namespace std;

template <typename T>
class SerialWriter
{
public:
    SerialWriter(ofstream ofs);
    void write(const T& val); 
    virtual ~SerialWriter();
};

#endif /* H_SERIALWRITER_H */
