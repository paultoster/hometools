##import win32com.client
##o = win32com.client.Dispatch("Outlook.Application")
##appointment = o.CreateItem(1)
##appointment.Start = '2010-10-30 10:00'
##appointment.Duration = 60
##appointment.Subject = 'Testeintrag aus Python'
##appointment.Location = 'Munich'
###recipients = appointment.Recipients.Add('max.muster@domain.de')
###appointment.requiredAttendees = recipients
##appointment.send
##appointment.save()

import win32com.client
import types

#DEBUG = 1
DEBUG = 0

class MsOutlook:
  records   = []
  keys      = []
  used_keys = []
  def __init__(self):
    self.outlookFound = 0
    try:
        self.oOutlookApp = \
            win32com.client.gencache.EnsureDispatch("Outlook.Application")
        self.outlookFound = 1
    except:
        print("MsOutlook: unable to load Outlook")
        self.outlookFound = 0

    self.records = []
    self.keys = []


  def loadContacts(self, keys=None):
    if not self.outlookFound:
      return

    # print "Loading MAPI ..."
    try:
      onMAPI = self.oOutlookApp.GetNamespace("MAPI")
    except:
      print("Error loading MAPI!")

    # print "Looking to load Redemption ..."
    # Set for Redemption DDL Installed
    RedemptionLib = -1
    try:
      Contact = win32com.client.Dispatch('Redemption.SafeContactItem')
      # print "Using Redemption."
      RedemptionLib = 0
    except:
      # print "No Redemption, loading standard."
      RedemptionLib = 1

    # print "Getting Default Folder ..."
    try:
      oContacts = \
            onMAPI.GetDefaultFolder(win32com.client.constants.olFolderContacts)
      #oContacts = onMAPI.GetDefaultFolder(10) # 10=outlook contacts folder
    except:
      print("Error loading Folder Contact")

    if DEBUG:
      print("number of contacts:", len(oContacts.Items))

    for oc in range(len(oContacts.Items)):

      if RedemptionLib:
        # Use Outlook directly
        Contact = oContacts.Items.Item(oc+1)
      else:
        # Use the Redemption Libary
        Contact.Item = oContacts.Items.Item(oc+1)

      #print Contact.Subject

      if Contact.Class == win32com.client.constants.olContact:

        if keys is None:
          # if we were't give a set of keys to use
          # then build up a list of keys that we will be
          # able to process
          # I didn't include fields of type time, though
          # those could probably be interpreted
          keys = []

          if RedemptionLib:
            # Use Outlook directly
            for key in Contact._prop_map_get_:
              if isinstance(getattr(Contact, key), (int, str, unicode)):
                keys.append(key)
          else:
            # Use the Redemption Libary
            for key in Contact.Item._prop_map_get_:
              if isinstance(getattr(Contact, key), (int, str, unicode)):
                keys.append(key)

          if DEBUG:
            keys.sort()
            print("Fields\n======================================")
            for key in keys:
              print(key)

        for key in keys:
          if( key not in self.keys ):
            self.keys.append(key)

        record = {}
        for key in keys:
            record[key] = getattr(Contact, key)
            if( DEBUG ):
              try:
                test = type(record[key])
                if(  ((test is types.StringType) and (len(record[key]) > 0)) ):
                  item = (key,'string')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)

                if( (test is types.UnicodeType) and (len(record[key]) > 0) ):
                  item = (key,'unicode')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)

                if ((test is types.ListType) and (len(record[key]) > 0)):
                  item = (key,'list')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)
                if((test is types.BooleanType) and record[key] ) :
                  item = (key,'bool')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)
                if(test is types.IntType ):
                  item = (key,'int')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)
                if(test is types.FloatType):
                  item = (key,'float')
                  if( item not in self.used_keys ):
                    self.used_keys.append(item)

  ##              else:
  ##                if(   test is not types.UnicodeType \
  ##                  and test is not types.StringType \
  ##                  and test is not types.ListType \
  ##                  and test is not types.BooleanType ):
  ##                  t = record[key]
              except:
                test = record[key]


      self.records.append(record)


if __name__ == '__main__':
    if DEBUG:
        print("Attempting to load Outlook ..")

    oOutlook = MsOutlook()
    # delayed check for Outlook on win32 box
    if not oOutlook.outlookFound:
        print("Outlook not found!")
        sys.exit(1)

    fields = ['FullName',
                'CompanyName',
                'MailingAddressStreet',
                'MailingAddressCity',
                'MailingAddressState',
                'MailingAddressPostalCode',
                'HomeTelephoneNumber',
                'BusinessTelephoneNumber',
                'MobileTelephoneNumber',
                'Email1Address',
                'Size',
                'Body'
                ]
    fields = [ 'FirstName','LastName','FullName','LastNameAndFirstName','FullNameAndCompany']

    if DEBUG:
        import time
        print("loading records...")
        startTime = time.time()

    # you can either get all of the data fields
    # or just a specific set of fields which is much faster
    if DEBUG:
      oOutlook.loadContacts()
      f = open("key_liste.txt","w")
      for key in oOutlook.keys:
        f.write("%s\n" % key)
      f.close()
      f = open("used_key_liste.txt","w")
      for key in oOutlook.used_keys:
        f.write("%s (%s)\n" % key)
      f.close()

    if DEBUG:
        print("loading took %f seconds" % (time.time() - startTime))

    print("Number of contacts: %d\n" % len(oOutlook.records))

    found = 0
    for i in range(len(oOutlook.records)):
      print("<%s><%s><%s><%s><%s>" % (oOutlook.records[i]['FirstName'] \
                                     ,oOutlook.records[i]['LastName'] \
                                     ,oOutlook.records[i]['FullName'] \
                                     ,oOutlook.records[i]['LastNameAndFirstName'] \
                                     ,oOutlook.records[i]['FullNameAndCompany'] \
                                     ))
      print("<%s><%s><%s><%s><%s>" % (oOutlook.records[i]['Email1Address'] \
                                     ,oOutlook.records[i]['Email1AddressType'] \
                                     ,oOutlook.records[i]['Email2Address'] \
                                     ,oOutlook.records[i]['Email3Address'] \
                                     ,oOutlook.records[i]['MailingAddress'] \
                                     ))
      if( oOutlook.records[i]['LastName'] == 'Mustermann' ):
        found = i+1

    if( found ):
      i = found-1
      liste = oOutlook.records[i].keys()
      for key in liste:
        print(key,' | ',oOutlook.records[i][key])

    oOutlook.loadContacts(fields)