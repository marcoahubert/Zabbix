# Veeam backup Versão Community

Como na versão community não tem a API liberada fiz a busca dos itens pelo Banco de dados Postgres, com isso fica limitados as seguintes informações:

* Job [Nome do Job] - Status
* Job [Nome do Job] - Last Start
* Job [Nome do Job] - Status

A parte de Repositorio até encontra mas os nomes já a parte de tamanho so por API.

User Parameter:

UserParameter=veeam.discovery.jobs,"C:\Program Files\PostgreSQL\15\bin\psql.exe" -h 127.0.0.1 -U postgres -d VeeamBackup -t -A -c "SELECT json_agg(json_build_object('{#JOBNAME}', name)) FROM public.\"bjobs\" WHERE type NOT IN (100,22000);"

UserParameter=veeam.job.status[*],"C:\Program Files\PostgreSQL\15\bin\psql.exe" -h 127.0.0.1 -U postgres -d VeeamBackup -t -A -c "SELECT COALESCE((SELECT result FROM public.\"backup.model.jobsessions\" s JOIN public.\"bjobs\" j ON j.id = s.job_id WHERE j.name = '$1' ORDER BY s.creation_time DESC LIMIT 1),-1);"

UserParameter=veeam.job.laststart[*],"C:\Program Files\PostgreSQL\15\bin\psql.exe" -h 127.0.0.1 -U postgres -d VeeamBackup -t -A -c "SELECT COALESCE(to_char(MAX(s.creation_time),'YYYY-MM-DD HH24:MI:SS'),'1900-01-01 00:00:00') FROM public.\"backup.model.jobsessions\" s WHERE s.job_name ILIKE '$1';"

UserParameter=veeam.job.lastend[*],"C:\Program Files\PostgreSQL\15\bin\psql.exe" -h 127.0.0.1 -U postgres -d VeeamBackup -t -A -c "SELECT COALESCE(to_char(MAX(s.end_time),'YYYY-MM-DD HH24:MI:SS'),'1900-01-01 00:00:00') FROM public.\"backup.model.jobsessions\" s WHERE s.job_name ILIKE '$1';"



OBS: caso de erro de timeout aumente o timeout do agent para 30, mas teve casos que não precisei alterar.
