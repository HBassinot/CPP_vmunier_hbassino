/** 
 * \file SerialWriter.hh
 * \author Vincent MUNIER
 */


#ifndef H_SERIALWRITER_H
#define H_SERIALWRITER_H

#include "SerialWriter.hh"
#include "SerialReader.hh"

class Serialize<T>
{
public:
    static void write(SerialWriter& sw, const T& val); 
    static void read(SerialReader& sr, T& val);
    static T* read_alloc(SerialReader& sr);
};

#endif /* H_SERIALWRITER_H */
