/////////////////////////////////////////////////////////////////////////
// IDENTLINE.H           Rex Schilasky
//
// Continental TEVES
//
/////////////////////////////////////////////////////////////////////////
#ifndef identline_h_included
#define identline_h_included

#include "mytypes.h"

#define STL_USING_STRING
#define STL_USING_VECTOR
#include "stl.h"


int GetLineTokens(const char* line_buf, StrVecT* pStrVec, bool make_copy = false);
int GetLineTokens(const char* line_buf, StrListT* pStrList, bool make_copy = false);
int IdentLineStr(const char* line_buf, std::string* str1 = NULL, std::string* str2 = NULL, std::string* str3 = NULL, std::string* str4 = NULL, std::string* str5 = NULL, std::string* str6 = NULL, std::string* str7 = NULL, std::string* str8 = NULL);
int IdentLineStr(const char* line_buf, StrVecT* pStrVec);
int IdentLineStr(const char* line_buf, StrListT* pStrList);


#endif // identline_h_included
