/** 
 * \file SerialReader.hh
 * \author Vincent MUNIER, Hervé BASSINOT
 */

#ifndef H_SERIALREADER_H
#define H_SERIALREADER_H

#include <fstream>
#include <iostream>
#include <typeinfo>
#include <sstream>

using namespace std;


class SerialReader
{
public:
    SerialReader(ifstream& infile);

    template <typename T>
    T* read_alloc() {
        T* val = new T();
	read(*val);
	return val;
    }

    template <typename T>
    void read(T& val) {
        string typeIdName;
        m_infile >> typeIdName;

        if (typeIdName != typeid(T).name())
            throw string("Error of type in read");


        m_infile >> val;
    }

    virtual ~SerialReader();

private:
    ifstream& m_infile;
};

#endif /* H_SERIALREADER_H */
