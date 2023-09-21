using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class Vehicle
    {
        public string License_No { get; set; }
        public int Seq { get; set; }
        public string Brand_No { get; set; }
        public string Model_No { get; set; }
        public string Chassis_No { get; set; }
        public string Color { get; set; }
        public DateTime Effective_Date { get; set; }
        public DateTime Expire_Date { get; set; }
        public decimal Service_Price { get; set; }
        public string Service_No { get; set; }
        public string Contract_No { get; set; }
        public int Customer_Id { get; set; }
        public string Contract_Type { get; set; }
        public string Std_Pmp { get; set; }
        public string Employee_Id { get; set; }
        public string Active_Flag { get; set; }
    }

}
