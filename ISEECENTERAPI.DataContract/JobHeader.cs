using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class JobHeader
    {
        public string Job_Id { get; set; }
        public string License_No { get; set; }
        public string Customer_Id { get; set; }
        public string Summary { get; set; }
        public string Action { get; set; }
        public string Result { get; set; }
        public string Transfer_To { get; set; }
        public DateTime Fix_Date { get; set; }
        public DateTime Close_Date { get; set; }
        public string Email_Customer { get; set; }
        public string Invoice_No { get; set; }
        public string Owner_Id { get; set; }
        public string Create_By { get; set; }
        public DateTime Create_Date { get; set; }
        public string Update_By { get; set; }
        public DateTime Update_Date { get; set; }
        public string Ref_HJob_Id { get; set; }
        public string Status { get; set; }
        public string type_job { get; set; }
        public string Job_Status { get; set; }
        public DateTime Receive_Date { get; set; }
        public DateTime Travel_Date { get; set; }
        public DateTime Job_Date { get; set; }
        public string Qt_Id { get; set; }
    }
}
