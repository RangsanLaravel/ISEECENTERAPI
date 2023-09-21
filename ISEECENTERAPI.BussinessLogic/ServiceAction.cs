using CryptoHelper;
using ISEECENTERAPI.DataAccess;
using ISEECENTERAPI.DataContract;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.BussinessLogic
{
    public class ServiceAction
    {
        private readonly string _connectionstring = string.Empty;
        private readonly CultureInfo culture = new CultureInfo("th-TH");
        private readonly string DBENV = string.Empty;
        public ServiceAction(string connectionstring, string DBENV)
        {
            this._connectionstring = connectionstring;            
            this.DBENV = DBENV;
        }

        public async ValueTask<List<Customer>> CounterCall(string fname)
        {
            List<Customer> dataObjects = null;
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {
                dataObjects = await repository.CounterCall(fname);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return dataObjects;
        }

        public async ValueTask<CounterDataDetail> GetCounterDetail(string customerID, string licenseNo)
        {
            CounterDataDetail dataObjects = new CounterDataDetail();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {
                dataObjects = await repository.GetCounterDetail(customerID, licenseNo);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return dataObjects;
        }

        public async ValueTask<employee_info> UserLogin(UserLogin user)
        {

            employee_info employee_Info = null;
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                employee_Info = await repository.UserLogin(user);
                if (employee_Info is null)
                    return employee_Info;
                if (!Crypto.VerifyHashedPassword(employee_Info.password, user.Password))
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return employee_Info;

        }

        public async ValueTask<List<tbm_application_center>> GETAPPLICATION(string USERID)
        {

            List<tbm_application_center> app = new List<tbm_application_center>();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                app = await repository.GETAPPLICATION(USERID);
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return app;

        }
    }
}
