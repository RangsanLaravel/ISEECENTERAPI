using ISEECENTERAPI.DataContract;
using ITUtility;
using DataAccessUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ISEECENTERAPI.DataAccess
{
    public class Repository
    {
        #region " STATIC "

        private readonly SqlConnection sqlConnection = null;
        private SqlTransaction transaction;

        private readonly string DBENV = string.Empty;
        public Repository(string connectionstring, string DBENV) : this(new SqlConnection(connectionstring), DBENV)
        {

        }
        public Repository(SqlConnection ConnectionString, string DBENV)
        {
            this.sqlConnection = ConnectionString;
            this.DBENV = DBENV;
        }
        public async ValueTask OpenConnectionAsync() =>
       await this.sqlConnection.OpenAsync();
        public async ValueTask CloseConnectionAsync() =>
       await this.sqlConnection.CloseAsync();

        public async ValueTask beginTransection() =>
            this.transaction = this.sqlConnection.BeginTransaction();

        public async ValueTask CommitTransection() =>
            this.transaction.Commit();


        public async ValueTask RollbackTransection() =>
            this.transaction.Rollback();
        #endregion " STATIC "

        #region " Counter "
        public async ValueTask<List<Customer>> CounterCall(string fname)
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT cus.customer_id,
		cus.cust_type,
		cus.address,
		(select td.district_name_tha from [{DBENV}].dbo.tbm_district  td where cus.district_code =td.district_code and td.status =1) as district_name_tha,
		(select std.sub_district_name_tha from [{DBENV}].dbo.tbm_sub_district std where std.sub_district_code = cus.sub_district_no and std.status=1) as sub_district_name_tha,
	    (select pr.province_name_tha from [{DBENV}].dbo.tbm_province pr where  pr.province_code =cus.province_code and pr.status =1) as province_name_tha,
		cus.zip_code,
		cus.phone_no,
		cus.Email,cus.fname
        FROM [{DBENV}].[dbo].[tbm_customer] cus
        WHERE fname LIKE @fname
              AND cus.status =1 "
            };
            sql.Parameters.AddWithValue("@fname", $"%{fname}%");

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<Customer>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }
        public async ValueTask<List<VehicleCus>> GET_LICENSE(string customer_id)
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT *
        FROM [{DBENV}].[dbo].[tbm_vehicle] 
        WHERE customer_id = @customer_id
              AND active_flag =1 "
            };
            sql.Parameters.AddWithValue("@customer_id", customer_id);

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<VehicleCus>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }
        public async ValueTask<CounterDataDetail> GetCounterDetail(string customerID, string licenseNo)
        {
            try
            {
                CounterDataDetail counterDetail = new CounterDataDetail();
                using (SqlCommand command = new SqlCommand($"[{DBENV}].dbo.CounterDetail", sqlConnection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    // เพิ่มพารามิเตอร์
                    command.Parameters.AddWithValue("@CustomerID", customerID);
                    command.Parameters.AddWithValue("@license_no", licenseNo);
                    DataSet dataSet = new DataSet();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataSet);
                    }
                    if (dataSet.Tables.Count >= 1)
                    {
                        counterDetail.customer = new Customer();
                        counterDetail.Vehicles = new List<Vehicle>();
                        counterDetail.JobHeaders = new List<JobHeader>();
                        counterDetail.EmailHistory = new List<EmailHistory>();
                        counterDetail.customer.VehicleCus = new List<VehicleCus>();
                        counterDetail.notiemail = new List<NotificationEmail>();

                        // Access the first DataTable
                        counterDetail.customer = dataSet.Tables[0].AsEnumerable<Customer>().FirstOrDefault();
                        counterDetail.Vehicles = dataSet.Tables[1].AsEnumerable<Vehicle>().ToList();
                        counterDetail.JobHeaders = dataSet.Tables[2].AsEnumerable<JobHeader>().ToList();
                        counterDetail.EmailHistory = dataSet.Tables[3].AsEnumerable<EmailHistory>().ToList();
                        counterDetail.customer.VehicleCus = dataSet.Tables[4].AsEnumerable<VehicleCus>().ToList();
                        counterDetail.notiemail = dataSet.Tables[5].AsEnumerable<NotificationEmail>().ToList();

                    }

                }
                return counterDetail;
            }
            catch (Exception ex)
            {

                throw new Exception($"{ex.Message} :{ex.StackTrace}");
            }
         
        }
        #endregion " Counter "

        #region " LIST DETAIL "
        public async ValueTask<List<crmmonitor>> GET_DETAIL_ALLJOB(searchalljob data)
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select {(string.IsNullOrEmpty(data.limit)?"":$"TOP {data.limit}")}
	cus.customer_id,
	fname,
	Email,
	phone_no,
	(select CONCAT(fullname,' ',lastname)  FROM [{DBENV}].[dbo].[tbm_employee] where user_id = hj.owner_id AND status =1) AS OWNER,
	(select CONCAT(fullname,' ',lastname)  FROM [{DBENV}].[dbo].[tbm_employee] where user_id = hj.transfer_to AND status =1) AS transfer_to,
	(select location_name FROM [{DBENV}].[dbo].[tbm_location_store] where owner_id = hj.owner_id AND status =1) AS location_name,
	hj.job_id,
    hj.license_no,
	jt.jobdescription,
	js.job_status_code,
	js.job_status_desc
from [{DBENV}].[dbo].[tbm_customer] cus
INNER JOIN [{DBENV}].[dbo].[tbt_job_header] hj on cus.customer_id =hj.customer_id
INNER JOIN [{DBENV}].[dbo].[tbm_jobtype] jt ON jt.jobcode =hj.type_job 
INNER JOIN [{DBENV}].[dbo].[tbm_job_status] js ON js.job_status_code =hj.job_status
WHERE cus.status =1
AND hj.status =1 
AND jt.status =1
AND (@owner_id IS NULL OR COALESCE(transfer_to,owner_id)= @owner_id)
AND (@fname IS NULL OR UPPER(fname) like UPPER(@fname))
AND  (@job_id IS NULL OR UPPER(hj.job_id) =UPPER(@job_id))
AND (@job_status_code IS NULL OR UPPER(hj.job_status) =UPPER(@job_status_code)) "
            };

            sql.Parameters.AddWithValue("@owner_id", string.IsNullOrWhiteSpace(data.owner_id)? (object)DBNull.Value: data.owner_id);
            sql.Parameters.AddWithValue("@fname", string.IsNullOrWhiteSpace(data.fname)? (object)DBNull.Value: $"%{data.fname}%");
            sql.Parameters.AddWithValue("@job_id", string.IsNullOrWhiteSpace(data.job_id) ? (object)DBNull.Value:data.job_id.ToUpper());
            sql.Parameters.AddWithValue("@job_status_code", string.IsNullOrWhiteSpace(data.job_status_code) ? (object)DBNull.Value:data.job_status_code);
            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<crmmonitor>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }

        public async ValueTask<List<substatus>> GET_SUBSTATUSAsync(string jobid)
        {
            List<substatus> dataObjects = new List<substatus>() ;
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT ms.STATUS_CODE,
       ms.STATUS_DESCRIPTION,
	   st.status_remark,
	   st.status_dt,
	   (select CONCAT(fullname,' ',lastname)  FROM [{DBENV}].[dbo].[tbm_employee] where user_id = st.create_id AND status =1) AS CREATE_BY   
  FROM [{DBENV}].[dbo].[tbt_job_substatus] st
  INNER JOIN [{DBENV}].[dbo].[tbm_substatus] ms ON ms.STATUS_CODE =st.substatus
  where st.active_flg =1
  AND ms.ACTIVE_FLG =1
  AND ms.STATUS_TYPE ='JOB'
  AND st.job_id =@Job_ID
ORDER BY st.STATUS_DT DESC "
            };
            sql.Parameters.AddWithValue("@Job_ID", jobid );

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    dataObjects = dt.AsEnumerable<substatus>().ToList();
                }
                else
                {
                    dataObjects = null;
                }
            }
            return dataObjects;
        }
        #endregion " LIST DETAIL " 

        #region " USER AND APPLICATION "
        public async ValueTask<employee_info> UserLogin(UserLogin user)
        {
            employee_info employee_Info = null;
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT  user_id
                                        ,em.user_name 
                                        ,em.password
                                        ,em.fullname
                                        ,em.lastname 
                                        ,em.position
                                        ,po.position_description   
                                        ,po.security_level
                                FROM [{DBENV}].[dbo].[tbm_employee] em 
                                LEFT JOIN [{DBENV}].[dbo].[tbm_employee_position] po on em.position =po.position_code
                                WHERE UPPER(em.user_name) =@username                               
                                AND em.status =1 
                                AND po.status =1"
            };
            command.Parameters.AddWithValue("@username", user.UserName.ToUpper());

            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    employee_Info = dt.AsEnumerable<employee_info>().First();
                }
            }
            return employee_Info;
        }

        public async ValueTask<List<tbm_application_center>> GETAPPLICATION(string USERID)
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbt_application_role rl
                    INNER JOIN [{DBENV}].dbo.tbm_application_center ap ON ap.application_id =rl.application_id and ap.application_status=1
                    WHERE rl.active_flg =1
                    AND  rl.user_id =@username"
            };
            command.Parameters.AddWithValue("@username", USERID);

            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_application_center>().ToList();
                }
                else
                    return null;
            }
        }

        #endregion " USER AND APPLICATION "

        #region " REPORT "
        public async ValueTask<List<tbm_report_center>> GET_REPORTCENTER()
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbm_report_center where active_flg =1"
            };
            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_report_center>().ToList();
                }
                else
                    return null;
            }
        }
        public async ValueTask<List<tbm_report_center_param>> GET_REPORT_PARAM(string rpt_id)
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbm_report_center_param where active_flg =1 and rpt_id =@rpt_id"
            };
            command.Parameters.AddWithValue("@rpt_id", rpt_id);
            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_report_center_param>().ToList();
                }
                else
                    return null;
            }
        }
        #endregion " REPORT "

        #region " DROP DOWN "
        public async ValueTask<List<tbm_employee>> GET_ALL_OWNER()
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@" SELECT user_id
      ,user_name
      ,password
      ,fullname
      ,lastname
      ,idcard
      ,position
      ,status
      ,create_date
      ,create_by
      ,update_date
      ,update_by
      ,showstock
      ,img_path
      ,technician_code
      ,sign_img
  FROM [{DBENV}].[dbo].[tbm_employee]
WHERE STATUS =1"
            };
          

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_employee>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }
       
        #endregion " DROP DOWN "

    }
}
