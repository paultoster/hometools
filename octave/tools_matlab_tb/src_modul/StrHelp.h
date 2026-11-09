/////////////////////////////////////////////////////////////////////////
// STRHELP.H             Rex Schilasky
//
// Continental TEVES
//
/////////////////////////////////////////////////////////////////////////
#ifndef strhelp_h_included
#define strhelp_h_included

#include <stdarg.h>
#include <math.h>
#include <stdio.h>
#include <ctype.h>

#define STL_USING_STRING
#include "stl.h"


/////////////////////////////////////////////////////////////////////////////
// Inline Functions

inline void StrTrimLeft(std::string* pstr, const char c = ' ');
inline void StrTrimRight(std::string* pstr, const char c = ' ');
inline void StrRemove(std::string* pstr, const char rem_char);
inline void StrReplace(std::string* pstr, const char* pold_char, const char* pnew_char, bool first_only /*= false*/);
inline void StrSpanIncluding(std::string* pstr, const char* span_str);
inline void StrFormat(std::string* pstr, const char* fstr,...);
inline void StrMakeLower(std::string* pstr);
inline bool StrGetLine(std::string& buf_str, std::string* pLine, bool read_no_comments = true);
inline bool StrGetKeyLine(std::string buf_str, std::string key_str, std::string* pLine, std::string* pArgs);
inline bool StrRemKeyLine(std::string& buf_str, std::string key_str);
inline bool StrSetFile(std::string file_name, std::string& buf_str);
inline bool StrGetFile(std::string file_name, std::string& buf_str);
inline bool StrGetFile(std::string file_name, const char** pBuf);
inline void StrAddComment(char** comment, std::string* pStr);
inline const char* StrMakeFString(double value, int post_min, int post_max);
inline void StrEncodeEscapes(std::string& str, char seq);
inline void StrDecodeEscapes(std::string& str, char seq);

inline char* itoa(int val);
inline char* dtoa(double val);


inline void StrTrimLeft(std::string* pstr, const char c /*= ' '*/)
{
  if(!pstr) return;
  if(!pstr->empty())
  {
    while((*pstr)[0] == c)
    {
      *pstr = pstr->erase(0, 1);
    }
  }
}

inline void StrTrimRight(std::string* pstr, const char c /*= ' '*/)
{
  if(!pstr->empty())
  {
    while((*pstr)[pstr->length()-1] == c)
    {
      *pstr = pstr->erase(pstr->length()-1, 1);
    }
  }
}

inline void StrRemove(std::string* pstr, const char rem_char)
{
  if(!pstr) return;
  if(!pstr->empty())
  {
    int n = 0;
    while((n = (int)pstr->find(rem_char)) != -1)
    {
      *pstr = pstr->erase(n, 1);
    }
  }
}

inline void StrReplace(std::string* pstr, const char* pold_char, const char* pnew_char, bool first_only = false)
{
  if(!pold_char) return;
  if(strcmp(pold_char, pnew_char) == 0) return;
  std::string sub_str = pold_char;
  int len_old = strlen(pold_char);
  int len_new = strlen(pnew_char);
  if(!pstr->empty() && !sub_str.empty())
  {
    int n = 0;
    while((n = pstr->find(sub_str, n)) != -1)
    {
      *pstr = pstr->erase(n, len_old);
      *pstr = pstr->insert(n, pnew_char);
      n += len_new;
      if(first_only) break;
    }
  }
}

inline void StrSpanIncluding(std::string* pstr, const char* span_str)
{
  if(!pstr) return;
  if(!pstr->empty())
  {
    int n = 0;
    while((n = pstr->find_first_not_of(span_str)) != -1)
    {
      *pstr = pstr->erase(n,1);
    }
  }
}

inline void StrFormat(std::string* pstr, const char* fstr,...)
{
  if(!pstr) return;
  char buf[512];

  va_list args;
  va_start(args, fstr);
#ifdef _WIN32
  int ret = _vsnprintf(buf, sizeof(buf)-1, fstr, args);
#else
  int ret = vsnprintf(buf, sizeof(buf)-1, fstr, args);
#endif
  if(ret > 0)
  {
    *pstr = buf;
  }
  else
  {
    *pstr = "";
  }
  va_end(args);
}

inline void StrFormat(std::string* pstr, const char* fstr, va_list args)
{
  if(!pstr) return;

  char buf[512];
#ifdef _WIN32
  int ret = _vsnprintf(buf, sizeof(buf)-1, fstr, args);
#else
  int ret = vsnprintf(buf, sizeof(buf)-1, fstr, args);
#endif
  if(ret > 0)
  {
    *pstr = buf;
    return;
  }
  else
  {
    *pstr = "";
    int buflen = 512;
    for(int iter = 0; iter < 16; iter++)
    {
      buflen *= 2;
      char* pBuf = new char[buflen];
      if(pBuf)
      {
#ifdef _WIN32
        int ret = _vsnprintf(pBuf, buflen-8, fstr, args);
#else
        int ret = vsnprintf(pBuf, buflen-8, fstr, args);
#endif
        if(ret > 0)
        {
          *pstr = pBuf;
          delete []pBuf;
          return;
        }
        else
        {
          *pstr = "";
        }
        delete []pBuf;
      }
    }
  }
}

inline void StrMakeLower(std::string* pstr)
{
  if(!pstr) return;
  std::string low_str;
  for(char* p = (char*)pstr->c_str(); *p; p++)
  {
    char c = (char)tolower(*p);
    low_str += c;
  }
  *pstr = low_str;
}

inline bool StrGetLine(std::string& buf_str, std::string* pLine, bool read_no_comments /* = true */)
{
  if(buf_str.empty()) return(false);
  if(!pLine) return(false);

  std::string line_str = "";
  while(!buf_str.empty())
  {
    int index = buf_str.find_first_of('\n');
    if(index == -1)
    {
      line_str = buf_str;
      buf_str = "";
    }
    else
    {
      line_str = buf_str.substr(0, index);
      buf_str = buf_str.substr(index+1, buf_str.length());
    }

    if(!line_str.empty())
    {
      char c = line_str[line_str.length()-1];
      if(c == '\r')
      {
        line_str.resize(line_str.length()-1);
      }

      if(!line_str.empty())
      {
        if(read_no_comments)
        {
          if((line_str[0] > 32) && (line_str[0] < 123))
          {
            *pLine = line_str;
            return(true);
          }
        }
        else
        {
          *pLine = line_str;
          return(true);
        }
      }
    }
  }
  return(false);
}

inline bool StrGetKeyLine(std::string buf_str, std::string key_str, std::string* pLine, std::string* pArgs)
{
  std::string line_str = "";
  while(StrGetLine(buf_str, &line_str, false))
  {
    StrTrimLeft(&line_str);
    StrTrimLeft(&key_str);
    std::string cut_str = line_str;
    int index = cut_str.find_first_of(" \t");
    if(index > 0) cut_str = cut_str.substr(0, index);
    if(cut_str == key_str)
    {
      if(!pLine && !pArgs) return(true);

      bool ret_state = false;
      if(pLine)
      {
        *pLine = line_str;
        ret_state = true;
      }
      if(pArgs)
      {
        std::string args = line_str.substr(key_str.length(), line_str.length());
        if(!args.empty())
        {
          *pArgs = args;
          ret_state = true;
        }
      }
      return(ret_state);
    }
  }
  return(false);
}

inline bool StrRemKeyLine(std::string& buf_str, std::string key_str)
{
  int start_index = buf_str.find(key_str);
  if(start_index < 0) return(false);
  int end_index = buf_str.find('\n', start_index);
  if(end_index <= start_index) return(false);
  buf_str.erase(start_index, end_index - start_index + 1);
  return(true);
}

inline bool StrSetFile(std::string file_name, std::string& buf_str)
{
  bool ret_state = false;

  FILE* fp = fopen(file_name.c_str(), "w");
  if(fp)
  {
    fprintf(fp, "%s", buf_str.c_str());
    fclose(fp);
    ret_state = true;
  }
  return(ret_state);
}

inline bool StrGetFile(std::string file_name, std::string& buf_str)
{
  if(file_name.empty()) return(false);
  bool ret_state = false;

  FILE* fp = fopen(file_name.c_str(), "r");
  if(fp)
  {
    fseek(fp, 0, SEEK_END);
    long flen = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if(flen > 0)
    {
      char* file_buf = new char[flen+1];
      if(file_buf)
      {
        long rd = fread(file_buf, sizeof(char), flen+1, fp);
        if(rd <= flen) file_buf[rd] = 0;
        buf_str += file_buf;
        delete []file_buf;
        ret_state = true;
      }
    }
    fclose(fp);
  }
  return(ret_state);
}

inline bool StrGetFile(std::string file_name, const char** pBuf)
{
  if(file_name.empty()) return(false);
  if(!pBuf)             return(false);

  bool ret_state = false;

  FILE* fp = fopen(file_name.c_str(), "r");
  if(fp)
  {
    fseek(fp, 0, SEEK_END);
    long flen = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if(flen > 0)
    {
      char* file_buf = new char[flen+1];
      if(file_buf)
      {
        long rd = fread(file_buf, sizeof(char), flen+1, fp);
        if(rd <= flen) file_buf[rd] = 0;
        *pBuf = file_buf;
        ret_state = true;
      }
    }
    fclose(fp);
  }
  return(ret_state);
}

inline void StrAddComment(char** comment, std::string* pStr)
{
  if(!comment) return;
  if(!pStr)    return;

  std::string new_str  = "";
  std::string line_str = "";
  while(StrGetLine(*pStr, &line_str, false))
  {
    std::string test_str = line_str;
    StrTrimLeft(&test_str);
    if(test_str.substr(0,3) != "#<#")
    {
      if(!new_str.empty() || (test_str != "\n"))
      {
        new_str += line_str + "\n";
      }
    }
  }

  char**      com_act = comment;
  std::string com_str = "";
  while(*com_act)
  {
    com_str = com_str + " #<#" + *com_act + "#>#" + "\n";
    com_act++;
  }

  *pStr = com_str + "\n\n" + new_str;
}

inline const char* StrMakeFString(double value, int post_min, int post_max)
{
  static std::string fstr;
  std::string tmp_str = "";
  fstr = "%.";

  int   i,
        post_colon = 0;

  long  dez,
        lvalue;

  if(post_max > 9) post_max = 9;

  dez = 1;
  i   = post_max;
  while(i)
  {
    dez *= 10;
    i--;
  }

  value  = value - (double)((int)value);
  value *= dez;
  lvalue = (long)(floor(value+0.5));

  i = 0;
  while(lvalue && dez)
  {
    if((lvalue/dez)*dez)
    {
      post_colon = i;
      lvalue %= dez;
    }
    i++;
    dez /= 10;
  }
  if(post_colon < post_min) post_colon = post_min;

  StrFormat(&tmp_str, "%d", post_colon);

  fstr += tmp_str;
  fstr += "f";

  return(fstr.c_str());
}

inline void StrEncodeEscapes(std::string& str, char seq)
{
  switch(seq)
  {
  case 'n':
    StrReplace(&str, "\\n", "\\\\n");
    StrReplace(&str, "\n", "\\n");
    break;
  case 'r':
    StrReplace(&str, "\\r", "\\\\r");
    StrReplace(&str, "\r", "\\r");
    break;
  case 't':
    StrReplace(&str, "\\t", "\\\\t");
    StrReplace(&str, "\t", "\\t");
    break;
  }
}

inline void StrDecodeEscapes(std::string& str, char seq)
{
  int pos = 0;
  while(pos < (int)str.length()-1)
  {
    if(str[pos] == '\\')
    {
      if(((pos == 0) || (str[pos-1] != '\\')) && (str[pos+1] == seq))
      {
        str.erase(pos, 1);
        switch(seq)
        {
        case 'n':
          str[pos] = '\n';
          break;
        case 'r':
          str[pos] = '\r';
          break;
        case 't':
          str[pos] = '\t';
          break;
        }
      }
    }
    pos++;
  }
  switch(seq)
  {
  case 'n':
    StrReplace(&str, "\\\\n", "\\n");
    break;
  case 'r':
    StrReplace(&str, "\\\\r", "\\r");
    break;
  case 't':
    StrReplace(&str, "\\\\t", "\\t");
    break;
  }
}

inline char* itoa(int val)
{
  static char num_buf[50];
#ifdef _WIN32
  _snprintf(num_buf, sizeof(num_buf), "%d", val);
#else
  snprintf(num_buf, sizeof(num_buf), "%d", val);
#endif
  return(num_buf);
}

inline char* ltoa(long val)
{
  static char num_buf[50];
#ifdef _WIN32
  _snprintf(num_buf, sizeof(num_buf), "%ld", val);
#else
  snprintf(num_buf, sizeof(num_buf), "%ld", val);
#endif
  return(num_buf);
}

inline char* dtoa(double val)
{
  static char num_buf[50];
#ifdef _WIN32
  _snprintf(num_buf, sizeof(num_buf), "%lf", val);
#else
  snprintf(num_buf, sizeof(num_buf), "%lf", val);
#endif
  return(num_buf);
}

#endif /* strhelp_h_included */
