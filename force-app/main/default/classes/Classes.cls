public class Classes extends fflib_SObjectDomain {
    public Classes(List<Class__c> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Classes(sObjectList);
        }
    }
    public override void onBeforeDelete() {
        List<Class__c> classList = ((new ClassesSelector()).classesWithFemaleStudents(existingRecords.keySet()));
        for(Class__c cl : classList) {
            if(cl.Students__r.size() > 1) {
                Class__c actualOldClass = (Class__c) existingRecords.get(cl.Id);
                actualOldClass.addError('Cannot delete Class having more than one Female Student!');
            }
        }
    }
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<Student__c> toBeDeletedStudentList = new List<Student__c>();
        Set<Id> resetStatusClassIdSet = new Set<Id>();
        for(Class__c cl : (List<Class__c>) Records) {
            Class__c oldClass = (Class__c) existingRecords.get(cl.Id);
            if(cl.Custom_Status__c != oldClass.Custom_Status__c && cl.Custom_Status__c == 'Reset') {
                resetStatusClassIdSet.add(cl.Id);
            }
        }
        toBeDeletedStudentList = ((new StudentsSelector()).getStudentsOfClasses(resetStatusClassIdSet));
        if(toBeDeletedStudentList != null && !toBeDeletedStudentList.isEmpty()) {
            delete toBeDeletedStudentList;
        }
    }
}