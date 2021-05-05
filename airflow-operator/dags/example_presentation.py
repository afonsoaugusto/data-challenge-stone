# [START import_module]
import datetime as dt
from datetime import datetime, timedelta

from airflow.models import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import BranchPythonOperator
# [END import_module]

# [START default_args]
default_args = {
    'owner': 'Afonso Rodrigues',
    'depends_on_past': False,
    'email': ['afonsoaugustoventura@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=1)}
# [END default_args]

# [START instantiate_dag]
dag = DAG(
    'test-data-pipeline',
    default_args=default_args,
    start_date=datetime(2021, 4, 1),
    schedule_interval='@hourly',
    tags=['test', 'development', 'bash'])
# [END instantiate_dag]

# [START basic_task]
check_s3_for_file_in_s3 = DummyOperator(task_id='check_s3_for_file_in_s3', dag=dag)
branching = BranchPythonOperator(
    task_id='branching', dag=dag,
    python_callable=lambda: 'branch_a'
)

branch_a = DummyOperator(task_id='branch_a', dag=dag)
spark_application = DummyOperator(task_id='spark_application', dag=dag)

branch_false = DummyOperator(task_id='branch_false', dag=dag)

join = DummyOperator(task_id='join', dag=dag)
# [END basic_task]

# [START task_sequence]
check_s3_for_file_in_s3 >> branching
branching >> branch_a >> spark_application >> join
branching >> branch_false >> join
# [END task_sequence]
