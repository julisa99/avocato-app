class LabelData{
   String name;
   int _id;
   bool isSet = false;

   int get id=> _id;

   LabelData(String newName, int id, bool isSetState){
     name = newName;
     _id= id;
     isSet = isSetState;
   }


}