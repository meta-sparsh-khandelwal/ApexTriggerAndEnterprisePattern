public class Students extends fflib_SObjectDomain {
    public Students(List<Student__c> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Students(sObjectList);
        }
    }
    public override void onBeforeInsert() {
        Map<Id, Class__c> classIdToClassMap = ((new ClassesSelector()).getClassesWithId());
        for(Student__c st : (List<Student__c>) Records) {
            if(classIdToClassMap.get(st.Class__c).MaxSize__c <= classIdToClassMap.get(st.Class__c).Students__r.size()) {
                st.addError('Cannot insert student as Class is full');
            }
        }
    }
    public override void onAfterInsert() {
        Map<Id, Integer> classIdToCountMap = new Map<Id, Integer>();
        Set<Id> classIdSet = new Set<Id>();
        for(Student__c st : (List<Student__c>) Records) {
            if(classIdToCountMap.get(st.Class__c) == null) {
                classIdToCountMap.put(st.Class__c,1);
            }
            else {
                classIdToCountMap.put(st.Class__c,classIdToCountMap.get(st.Class__c)+1);
            }
            classIdSet.add(st.Class__c);
        }
        updateClasses(classIdSet,classIdToCountMap);
    }
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        Map<Id, Integer> classIdToCountMapInc = new Map<Id, Integer>();
        Map<Id, Integer> classIdToCountMapDec = new Map<Id, Integer>();
        Set<Id> incClassIdSet = new Set<Id>();
        Set<Id> decClassIdSet = new Set<Id>();
        for(Student__c st : (List<Student__c>) Records) {
            Student__c oldStu = (Student__c)existingRecords.get(st.Id);
            if(oldStu.class__c != st.class__c) {
                if(classIdToCountMapDec.get(oldStu.class__c) == null) {
                    classIdToCountMapDec.put(oldStu.class__c,-1);
                }
                else {
                    classIdToCountMapDec.put(oldStu.class__c,classIdToCountMapDec.get(oldStu.class__c)-1);
                }
                if(classIdToCountMapInc.get(st.class__c) == null) {
                    classIdToCountMapInc.put(st.class__c,1);
                }
                else {
                    classIdToCountMapInc.put(st.class__c,classIdToCountMapInc.get(st.class__c)+1);
                }
                decClassIdSet.add(oldStu.Class__c);
            	incClassIdSet.add(st.Class__c);
            }
        }
        updateClasses(decClassIdSet,classIdToCountMapDec);
        updateClasses(incClassIdSet,classIdToCountMapInc);
    }
    public override void onAfterDelete() {
        Map<Id, Integer> classIdToCountMapDec = new Map<Id, Integer>();
        Set<Id> decClassIdSet = new Set<Id>();
        for(Id studentId : existingRecords.keySet()) {
            Student__c oldStu = (Student__c)existingRecords.get(studentId);
            if(classIdToCountMapDec.get(oldStu.class__c) == null) {
                classIdToCountMapDec.put(oldStu.class__c,-1);
            }
            else {
                classIdToCountMapDec.put(oldStu.class__c,classIdToCountMapDec.get(oldStu.class__c)-1);
            }
            decClassIdSet.add(oldStu.Class__c);
        }
        updateClasses(decClassIdSet,classIdToCountMapDec);
    }
    @TestVisible
    private void updateClasses(Set<Id> classIdSet, Map<Id, Integer> classIdToCountMap) {
        if(classIdToCountMap != null || !classIdToCountMap.isEmpty()) {
            List<Class__c> classList = ((new ClassesSelector()).selectById(classIdSet));
            for(Class__c cl : classList) {
                cl.MyCount__c = cl.MyCount__c + (classIdToCountMap.get(cl.Id));
            }
            update classList;
        }
    }
}