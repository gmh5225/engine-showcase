#ifndef __FILEBUFFER_H
#define __FILEBUFFER_H

#include <string>

/*!
	A container for file stream information
*/
struct FileBuffer
{

public:

	FileBuffer( char* fileBytes, const int& fileLength, const std::string& filePath )
		: fileBytes( fileBytes )
		, fileLength( fileLength )
		, filePath( filePath )
	{

	}

	~FileBuffer( )
	{
		if( fileBytes != 0 )
		{
			delete fileBytes;
		}
	}

	int fileLength;
	const std::string filePath;
	char* fileBytes;

private:

	FileBuffer( )
		: fileBytes( 0 )
		, fileLength( 0 )
		, filePath( 0 )
	{

	}

	FileBuffer( const FileBuffer & copy ) { };
	FileBuffer & operator = ( const FileBuffer & copy ) { return *this; };

};

#endif
