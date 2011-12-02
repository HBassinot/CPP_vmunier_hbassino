/** 
 * \file SerialWriter.hh
 * \author Vincent MUNIER, Hervé BASSINOT
 */


#ifndef H_SERIALIZE_H
#define H_SERIALIZE_H
 

#include "SerialWriter.hh"
#include "SerialReader.hh"

template <class T>
class Serialize
{
public:
    static void write(SerialWriter& sw, const T& val); 
    static void read(SerialReader& sr, T& val);
    static T* read_alloc(SerialReader& sr); 
};


#endif /* H_SERIALIZE_H */

