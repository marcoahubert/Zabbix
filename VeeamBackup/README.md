#Veeam backup Versão Community

Como na versão community não tem a API liberada fiz a busca dos itens pelo Banco de dados Postgres, com isso fica limitados as seguintes informações:

* Job [Nome do Job] - Status
* Job [Nome do Job] - Last Start
* Job [Nome do Job] - Status

A parte de Repositorio até encontra mas os nomes já a parte de tamanho so por API.

User Parameter:

# LLD Jobs
UserParameter=veeam.discovery.jobs,"C:\Program Files\PostgreSQL\15\bin\psql.exe" -h 127.0.0.1 -U postgres -d VeeamBackup -t -c "SELECT json_agg(json_build_object('{#JOBNAME}', name)) FROM public.\"backup.model.jobsessions\";"

# Último status do Job
UserParameter=veeam.job.status[*],psql -h 127.0.0.1 -U veeam -d VeeamBackup -t -c "SELECT s.result FROM public.\"Backup.Model.JobSessions\" s JOIN public.\"Jobs\" j ON j.id=s.idjob WHERE j.name='$1' ORDER BY s.creation_time DESC LIMIT 1;"

# Último start
UserParameter=veeam.job.laststart[*],psql -h 127.0.0.1 -U veeam -d VeeamBackup -t -c "SELECT to_char(s.creation_time,'YYYY-MM-DD HH24:MI:SS') FROM public.\"Backup.Model.JobSessions\" s JOIN public.\"Jobs\" j ON j.id=s.idjob WHERE j.name='$1' ORDER BY s.creation_time DESC LIMIT 1;"

# Último end
UserParameter=veeam.job.lastend[*],psql -h 127.0.0.1 -U veeam -d VeeamBackup -t -c "SELECT to_char(s.end_time,'YYYY-MM-DD HH24:MI:SS') FROM public.\"Backup.Model.JobSessions\" s JOIN public.\"Jobs\" j ON j.id=s.idjob WHERE j.name='$1' ORDER BY s.creation_time DESC LIMIT 1;"


OBS: caso de erro de timeout aumente o timeout do agent para 30, mas teve casos que não precisei alterar.
