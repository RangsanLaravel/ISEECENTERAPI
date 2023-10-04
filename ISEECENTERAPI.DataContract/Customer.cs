using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class Customer
    {
        public string customer_id { get; set; }
        public string fname { get; set; }
        public string cust_type { get; set; }
        public string Address { get; set; }
        public string district_name_tha { get; set; }
        public string sub_district_name_tha { get; set; }
        public string province_name_tha { get; set; }
        public string Zip_Code { get; set; }
        public string Phone_No { get; set; }
        public string Email { get; set; }
        public List<VehicleCus> VehicleCus { get; set; }
    }
}
