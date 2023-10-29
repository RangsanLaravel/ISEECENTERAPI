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
        public string email { get; set; }
        public string phone_no { get; set; }
        public string owner { get; set; }
        public string tranfer_to { get; set; }
        public string location_name { get; set; }
        public string job_id { get; set; }
        public string jobdescription { get; set; }
        public string job_status_code { get; set; }
        public string job_status_desc { get; set; }
        public List<substatus> job_substatus { get; set; }
    }
}
