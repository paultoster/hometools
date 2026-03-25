import numpy as np

class NpBaseClass:
    def __init__(self,args,np_name_list,class_def) -> None:

        self.class_def = class_def

        if len(args) == 0:
            for name in np_name_list:
                self.__setattr__(name, None)
            # end for
        else:
            n = len(np_name_list)
            count = 0
            for i,val in enumerate(args):

                if i < n:
                    self.__setattr__(np_name_list[i], val)
                    count += 1
                # end if
            # end for
            if count != n:
                raise Exception(f"NpBaseClass init ging schief Anzahl args: {count} ist ungleich anzulegenden {n = }")
            # end if
        # end if
        return
    def to_dict(self):
        class_vars = vars(self.class_def)  # get any "default" attrs defined at the class level
        inst_vars = vars(self)  # get any attrs defined on the instance (self)
        all_vars = dict(class_vars)
        all_vars.update(inst_vars)
        # filter out private attributes
        public_vars = {k: v for k, v in all_vars.items() if not k.startswith('_')}
        return public_vars
    # end def
    def to_store_dict(self):
        ddict = self.to_dict()
        ddict_trans = {}
        for key, value in ddict.items():

            if key in self.np_name_list:
                ddict_trans[key] = [ddict[key].tolist(),ddict[key].shape]
            else:
                ddict_trans[key] = value
            # end if
        # end for
        return ddict_trans
    # end def
    def from_store_dict(self,ddict):

        count = 0
        for key, value in ddict.items():

            if key in self.np_name_list:
                np_array = np.array(ddict[key][0]).reshape(ddict[key][1])
                self.__setattr__(key, np_array)
                count += 1
            else:
                self.__setattr__(key, value)
            # end if
        # end for
        if count != len(self.np_name_list):
            raise Exception(f"NpBaseClass init ging schief Anzahl args: {count} ist ungleich anzulegenden n = {len(self.np_name_list)}")
        return
    # end def
    def __str__(self):
        return f"NpBaseClass mit np_arrays: {self.np_name_list} und file_base_name = {self.file_base_name}  "
    # end def
# end class

class NpUsdEuroClass(NpBaseClass):
    np_name_list: list[str] = ["dat_np_array","usdeuro_np_array"]
    file_base_name: str = "usdeuro_values"
    def __init__(self,*args):
        super().__init__(args,np_name_list=self.np_name_list,class_def = NpUsdEuroClass)
        return
    # end def

if __name__ == '__main__':

    np_dat_array = np.array([0,1,2,3,4,5,6])
    np_ue_array = np.array([1.2,1.3,1.25,1.5,1.4,1.3,1.6])
    obj = NpUsdEuroClass(np_dat_array,np_ue_array)

    ddict_trans = obj.to_store_dict()
    print(ddict_trans)

    obj1 = NpUsdEuroClass()
    obj1.from_store_dict(ddict_trans)

    print(obj1.dat_np_array)
    print(obj1.usdeuro_np_array)
