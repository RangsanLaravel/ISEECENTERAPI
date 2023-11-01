using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class crmmonitor
    {
        public string customer_id { get; set; }
        public string fname { get; set; }
        public string website { get; set; }
        public string contract { get; set; }
        public string position { get; set; }
        public string email { get; set; }
        public string phone_no { get; set; }
        public string owner { get; set; }
        public string Model_type { get; set; }
        public string location_name { get; set; }
        public string People { get; set; }
        public string Priority { get; set; }
        public string Deal_creation_date { get; set; }
        public string Due_date_follow_up { get; set; }
        public string Deal_value {get;set;}
        public string Percen {get;set;}
        public string Won {get;set; }
        public string tranfer_to { get; set; }
        public string job_id { get; set; }
        public string jobdescription { get; set; }
        public string job_status_code { get; set; }
        public string job_status_desc { get; set; }
        public List<substatus> job_substatus { get; set; }
    }
}
