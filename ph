#!/usr/bin/env python3
# task_manager_advanced.py

import argparse
import json
import os
import csv
from datetime import datetime

TASKS_FILE = "tasks_advanced.json"


# -------------------------------------------
#  Utilities
# -------------------------------------------
def load_tasks():
    if not os.path.exists(TASKS_FILE):
        return []
    try:
        with open(TASKS_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError:
        return []


def save_tasks(tasks):
    with open(TASKS_FILE, "w", encoding="utf-8") as f:
        json.dump(tasks, f, ensure_ascii=False, indent=2)


def generate_id(tasks):
    return max((t["id"] for t in tasks), default=0) + 1


def validate_date(date_str):
    try:
        if date_str == "":
            return None
        return datetime.strptime(date_str, "%Y-%m-%d").strftime("%Y-%m-%d")
    except ValueError:
        print("❌ التاريخ يجب أن يكون بصيغة YYYY-MM-DD")
        exit(1)


# -------------------------------------------
#  Commands
# -------------------------------------------
def add_task(title, priority, due_date, description):
    tasks = load_tasks()
    new_task = {
        "id": generate_id(tasks),
        "title": title,
        "priority": priority,
        "description": description,
        "due_date": due_date,
        "done": False,
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M")
    }
    tasks.append(new_task)
    save_tasks(tasks)
    print(f"✅ تمت إضافة المهمة #{new_task['id']} بنجاح!")


def list_tasks(sort_by=None, show_all=False):
    tasks = load_tasks()

    if not show_all:
        tasks = [t for t in tasks if not t["done"]]

    if sort_by == "priority":
        priority_order = {"High": 1, "Medium": 2, "Low": 3}
        tasks.sort(key=lambda t: priority_order[t["priority"]])

    elif sort_by == "date":
        tasks.sort(key=lambda t: t["due_date"] or "9999-99-99")

    elif sort_by == "status":
        tasks.sort(key=lambda t: t["done"])

    if not tasks:
        print("📭 لا توجد مهام.")
        return

    for t in tasks:
        status = "✔️" if t["done"] else "❌"
        print(
            f"\n📌 **{t['title']}**"
            f"\n   رقم: {t['id']}"
            f"\n   الأولوية: {t['priority']}"
            f"\n   تاريخ الاستحقاق: {t['due_date'] or 'لا يوجد'}"
            f"\n   مكتملة: {status}"
            f"\n   الوصف: {t['description']}"
            f"\n   أُنشئت في: {t['created_at']}"
        )


def mark_done(task_id):
    tasks = load_tasks()
    for t in tasks:
        if t["id"] == task_id:
            t["done"] = True
            save_tasks(tasks)
            print(f"✅ تم تعليم المهمة #{task_id} كمكتملة")
            return
    print("❌ لم يتم العثور على المهمة.")


def edit_task(task_id, new_title, new_priority, new_due, new_desc):
    tasks = load_tasks()
    for t in tasks:
        if t["id"] == task_id:
            if new_title: t["title"] = new_title
            if new_priority: t["priority"] = new_priority
            if new_due: t["due_date"] = validate_date(new_due)
            if new_desc: t["description"] = new_desc
            save_tasks(tasks)
            print(f"✏️ تم تعديل المهمة #{task_id}")
            return
    print("❌ لم يتم العثور على المهمة.")


def search_tasks(keyword):
    tasks = load_tasks()
    results = [t for t in tasks if keyword.lower() in t["title"].lower()]

    if not results:
        print("🔍 لا توجد نتائج.")
        return

    for t in results:
        print(f"- {t['id']}: {t['title']} (أولوية {t['priority']})")


def delete_task(task_id):
    tasks = load_tasks()
    new_tasks = [t for t in tasks if t["id"] != task_id]
    save_tasks(new_tasks)
    print(f"🗑️ تم حذف المهمة #{task_id}")


def export_csv(filename):
    tasks = load_tasks()
    with open(filename, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["ID", "Title", "Priority", "Due Date", "Done", "Description"])
        for t in tasks:
            writer.writerow([t["id"], t["title"], t["priority"], t["due_date"], t["done"], t["description"]])
    print(f"📄 تم تصدير المهام إلى {filename}")


# -------------------------------------------
#  Argparse CLI
# -------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="Advanced Task Manager CLI")
    sub = parser.add_subparsers(dest="cmd")

    # add
    add = sub.add_parser("add")
    add.add_argument("title")
    add.add_argument("--priority", choices=["High", "Medium", "Low"], default="Medium")
    add.add_argument("--due", default="")
    add.add_argument("--desc", default="")

    # list
    lst = sub.add_parser("list")
    lst.add_argument("--sort", choices=["priority", "date", "status"])
    lst.add_argument("--all", action="store_true")

    # done
    done = sub.add_parser("done")
    done.add_argument("id", type=int)

    # edit
    edit = sub.add_parser("edit")
    edit.add_argument("id", type=int)
    edit.add_argument("--title")
    edit.add_argument("--priority")
    edit.add_argument("--due")
    edit.add_argument("--desc")

    # search
    search = sub.add_parser("search")
    search.add_argument("keyword")

    # delete
    delete = sub.add_parser("delete")
    delete.add_argument("id", type=int)

    # export
    export = sub.add_parser("export")
    export.add_argument("file")

    args = parser.parse_args()

    if args.cmd == "add":
        add_task(args.title, args.priority, validate_date(args.due), args.desc)

    elif args.cmd == "list":
        list_tasks(args.sort, args.all)

    elif args.cmd == "done":
        mark_done(args.id)

    elif args.cmd == "edit":
        edit_task(args.id, args.title, args.priority, args.due, args.desc)

    elif args.cmd == "search":
        search_tasks(args.keyword)

    elif args.cmd == "delete":
        delete_task(args.id)

    elif args.cmd == "export":
        export_csv(args.file)

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
