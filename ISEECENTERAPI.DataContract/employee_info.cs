using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class employee_info
    {
        public string token { get; set; }
        public string user_id { get; set; }
        public string user_name { get; set; }
        public string password { get; set; }
        public string fullname { get; set; }
        public string lastname { get; set; }
        public string position { get; set; }
        public string position_description { get; set; }
        public string security_level { get; set; }
        public List<tbm_application_center> application { get; set; }
    }
}
