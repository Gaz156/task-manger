 git clone https://github.com/yourname/task_manager_advanced.git
\ cd task_manager_advanced

 python3 --version
 chmod +x task_manager_advanced.py
 python3 task_manager_advanced.py [command] [options]
 ./task_manager_advanced.py [command] [options]
 python3 task_manager_advanced.py add "Buy groceries" \
  --priority High \
  --due 2025-01-10 \
  --desc "Milk, bread, eggs"
 python3 task_manager_advanced.py list
 python3 task_manager_advanced.py list --all
python3 task_manager_advanced.py list --sort priority
python3 task_manager_advanced.py list --sort date
python3 task_manager_advanced.py list --sort status

 python3 task_manager_advanced.py done 3
 python3 task_manager_advanced.py edit 2 \
  --title "Updated title" \
  --priority Low \
  --due 2025-01-15 \
  --desc "Updated description"
## python3 task_manager_advanced.py search "project"
## python3 task_manager_advanced.py delete 5
## python3 task_manager_advanced.py export tasks.csv

