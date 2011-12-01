/** 
 * \file SerialReader.hh
 * \author Vincent MUNIER, 
 */


#ifndef H_SERIALWRITER_H
#define H_SERIALWRITER_H

#include <fstream>
using namespace std;

template <typename T>
class SerialReader
{
public:
    SerialReader(ifstream ifs);
    T* read_alloc();
    void read(T& val);
    virtual ~SerialReader();
};

#endif /* H_SERIALWRITER_H */
