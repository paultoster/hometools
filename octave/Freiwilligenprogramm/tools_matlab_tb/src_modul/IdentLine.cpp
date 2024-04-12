/////////////////////////////////////////////////////////////////////////
// IDENTLINE.CPP         Rex Schilasky
//
// Continental TEVES
//
/////////////////////////////////////////////////////////////////////////

#include <string.h>
#include "identline.h"


/////////////////////////////////////////////////////////////////////////
// IdentLineStr

int GetLineTokens(const char* line_buf, StrVecT* pStrVec, bool make_copy /* = false */)
{
  if(!pStrVec)  return(0);
  if(!line_buf) return(0);
  pStrVec->clear();

  char seps[]  = " \t\r\n";
  char *token;
  char* string = NULL;
  if(make_copy)
  {
    size_t len = strlen(line_buf);
    string = new char[len+1];
    memcpy(string, line_buf, len+1);
  }
  else
  {
    string = (char*)line_buf;
  }

  token = strtok(string, seps );
  while(token != NULL)
  {
    pStrVec->push_back(token);
    token = strtok( NULL, seps );
  }

  if(make_copy)
  {
    delete []string;
  }

  return((int)pStrVec->size());
}

int GetLineTokens(const char* line_buf, StrListT* pStrList, bool make_copy /* = false */)
{
  if(!pStrList) return(0);
  if(!line_buf) return(0);
  pStrList->clear();

  char seps[]  = " \t\r\n";
  char *token;
  char* string = NULL;
  if(make_copy)
  {
    size_t len = strlen(line_buf);
    string = new char[len+1];
    memcpy(string, line_buf, len+1);
  }
  else
  {
    string = (char*)line_buf;
  }

  token = strtok(string, seps );
  while(token != NULL)
  {
    pStrList->push_back(token);
    token = strtok( NULL, seps );
  }

  if(make_copy)
  {
    delete []string;
  }

  return((int)pStrList->size());
}

int IdentLineStr(const char* line_buf, std::string* str1 /*= NULL*/, std::string* str2 /*= NULL*/, std::string* str3 /*= NULL*/, std::string* str4 /*= NULL*/, std::string* str5 /*= NULL*/, std::string* str6 /*= NULL*/, std::string* str7 /*= NULL*/, std::string* str8 /*= NULL*/)
{
  int ret_state = 0;

  StrVecT TokVec;
  IdentLineStr(line_buf, &TokVec);

  if(str1 && TokVec.size() > 0) {*str1 = TokVec[0]; ret_state = 1;};
  if(str2 && TokVec.size() > 1) {*str2 = TokVec[1]; ret_state = 2;};
  if(str3 && TokVec.size() > 2) {*str3 = TokVec[2]; ret_state = 3;};
  if(str4 && TokVec.size() > 3) {*str4 = TokVec[3]; ret_state = 4;};
  if(str5 && TokVec.size() > 4) {*str5 = TokVec[4]; ret_state = 5;};
  if(str6 && TokVec.size() > 5) {*str6 = TokVec[5]; ret_state = 6;};
  if(str7 && TokVec.size() > 6) {*str7 = TokVec[6]; ret_state = 7;};
  if(str8 && TokVec.size() > 7) {*str8 = TokVec[7]; ret_state = 8;};

  return(ret_state);
}

int IdentLineStr(const char* line_buf, StrVecT* pStrVec)
{
  if(!line_buf || !pStrVec) return(0);
  pStrVec->clear();

  StrListT TokList;
  IdentLineStr(line_buf, &TokList);

  StrListT::iterator iter = TokList.begin();
  while(iter != TokList.end())
  {
    pStrVec->push_back(*iter);
    iter++;
  }
  return((int)pStrVec->size());
}

int IdentLineStr(const char* line_buf, StrListT* pStrList)
{
  if(!line_buf || !pStrList) return(0);
  pStrList->clear();

  std::string line_str = line_buf;
  if(line_str.empty()) return(0);
  bool has_quotes = (line_str.find_first_of('\"') != std::string::npos) || (line_str.find_first_of('\'') != std::string::npos);

  if(has_quotes)
  {
    std::string tok_str = "";

    if(line_buf)
    {
      int  line_index = 0;
      int  str_num    = 0;
      bool str_act    = false;
      char quoted     = 0;
      char c ;

      c = line_buf[line_index];
      while(c)
      {
        if(!str_act)
        {
          if((c != ' ') && (c != '\t') && (c != '\r') && (c != '\n'))
          {
            str_act = true;
            str_num++;
            if((c == '\"') || (c == '\''))
            {
              if(line_buf[line_index+1] != c) line_index++;
              quoted = c;
            }
            else
            {
              quoted = 0;
            }
          }
          if(str_act)
          {
            tok_str = "";
          }
        }
        else
        {
          if(!quoted)
          {
            if((c == ' ') || (c == '\t') || (c == '\r') || (c == '\n'))
            {
              str_act = false;
            }
          }
          else
          {
            if(c == quoted)
            {
              str_act = false;
            }
          }
          if(!str_act)
          {
            pStrList->push_back(tok_str);
            tok_str = "";
          }
        }

        if(str_act)
        {
          bool add = false;
          if(!quoted)
          {
            if(  (line_buf[line_index] != '\0')
              && (line_buf[line_index] != '\r')
              && (line_buf[line_index] != '\n')
              )
              add = true;
          }
          else
          {
            if(  (line_buf[line_index] != '\0')
              && (line_buf[line_index] != quoted)
              )
              add = true;
          }
          if(add)
          {
            if(str_act)
            {
              tok_str += line_buf[line_index];
            }
          }

        }
        line_index++;
        c = line_buf[line_index];
      }

      if(tok_str != "")
      {
        pStrList->push_back(tok_str);
      }
    }
  }
  else
  {
    GetLineTokens(line_buf, pStrList, true);
  }

  return((int)pStrList->size());
}
