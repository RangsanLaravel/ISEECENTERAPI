using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class tbm_report_center
    {
      public string rpt_id {get;set;}
      public string rpt_code {get;set;}
      public string rpt_name {get;set;}
      public string rpt_store {get;set;}
      public string active_flg {get;set;}
      public string create_dt {get;set;}
      public string create_by {get;set;}
      public string upd_dt {get;set;}
      public string upd_by { get; set; }
        public List<tbm_report_center_param> Params { get; set; }
    }
}
