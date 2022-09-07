public class StudentsSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Student__c.Id,
                Student__c.FirstName__c,
                Student__c.Class__c };
                    }
    public Schema.SObjectType getSObjectType() {
        return Student__c.sObjectType;
    }
    public List<Student__c> getStudentsOfClasses(Set<Id> classIdSet) {
        return [SELECT Id, FirstName__c FROM Student__c WHERE Class__c IN :classIdSet];
    }
}