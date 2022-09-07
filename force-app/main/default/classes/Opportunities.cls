public class Opportunities extends fflib_SObjectDomain {
    public Opportunities(List<Opportunity> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Opportunities(sObjectList);
        }
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        for(Opportunity opp : (List<Opportunity>) Records) {
            Opportunity oldOpp = (Opportunity)existingRecords.get(opp.Id);
            if((oldOpp.StageName != 'Closed Won' || oldOpp.StageName != 'Closed Lost')
               && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')) {
                opp.CloseDate = Date.today();
            }
        }
    }
}