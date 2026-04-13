#!/usr/bin/env python3
import os, sys, re
from datetime import datetime

MEMORY_DIR = os.path.expanduser("~/.config/opencode/memory")
MEMORY_FILE = os.path.join(MEMORY_DIR, "MEMORY.md")
TOPICS_DIR = os.path.join(MEMORY_DIR, "topics")
RAW_DIR = os.path.join(MEMORY_DIR, "raw")
FAILED_LOG = os.path.join(RAW_DIR, "failed-writes.log")

def ensure_dirs():
    os.makedirs(TOPICS_DIR, exist_ok=True)
    os.makedirs(RAW_DIR, exist_ok=True)

def log_failure(action, reason):
    os.makedirs(RAW_DIR, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(FAILED_LOG, "a") as f:
        f.write("[" + ts + "] " + action + ": " + reason + "\n")

def resolve_topic_path(topic_ref):
    """Resolve a topic reference like 'topics/project.md' or 'project.md' to absolute path."""
    if topic_ref.startswith("topics/"):
        topic_ref = topic_ref[7:]
    return os.path.join(TOPICS_DIR, topic_ref)

def verify_topic(topic_ref):
    full_path = resolve_topic_path(topic_ref)
    if not os.path.isfile(full_path):
        return False, "File non esiste: " + full_path
    try:
        with open(full_path, "r") as f:
            content = f.read()
    except Exception as e:
        return False, "Errore lettura: " + str(e)
    if len(content.strip()) < 10:
        return False, "File troppo corto (" + str(len(content)) + " chars)"
    return True, "Validato (" + str(len(content)) + " chars)"

def add_pointer(category, description, topic_ref):
    ensure_dirs()
    valid, message = verify_topic(topic_ref)
    if not valid:
        log_failure("ADD [" + category + "]", topic_ref + " - " + message)
        print("FAIL: " + message)
        return False
    today = datetime.now().strftime("%Y-%m-%d")
    new_line = "[" + category + "] " + description + " -> " + topic_ref + " (verified " + today + ")"
    if os.path.isfile(MEMORY_FILE):
        with open(MEMORY_FILE, "r") as f:
            content = f.read()
        if topic_ref in content:
            pattern = r"\[.*?\].*?-> " + re.escape(topic_ref) + r".*"
            content = re.sub(pattern, new_line, content)
            action = "UPDATED"
        else:
            content = content.rstrip() + "\n" + new_line + "\n"
            action = "ADDED"
    else:
        content = "# MEMORY.md\n" + new_line + "\n"
        action = "CREATED"
    try:
        with open(MEMORY_FILE, "w") as f:
            f.write(content)
        print("OK " + action + ": [" + category + "] " + description + " -> " + topic_ref)
        return True
    except Exception as e:
        log_failure("WRITE [" + category + "]", str(e))
        print("FAIL: " + str(e))
        return False

def verify_all():
    ensure_dirs()
    if not os.path.isfile(MEMORY_FILE):
        print("WARN: MEMORY.md non esiste")
        return
    with open(MEMORY_FILE, "r") as f:
        lines = f.readlines()
    valid = 0
    invalid = 0
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        match = re.search(r"->\s*(topics/\S+)\s*\(verified", line)
        if not match:
            print("WARN Formato non valido: " + line[:80])
            invalid += 1
            continue
        topic_ref = match.group(1)
        is_valid, message = verify_topic(topic_ref)
        if is_valid:
            valid += 1
        else:
            invalid += 1
            print("FAIL " + line[:80] + " - " + message)
    print("Verifica: " + str(valid) + " validi, " + str(invalid) + " invalidi")

def remove_pointer(category):
    ensure_dirs()
    if not os.path.isfile(MEMORY_FILE):
        print("WARN: MEMORY.md non esiste")
        return False
    with open(MEMORY_FILE, "r") as f:
        lines = f.readlines()
    new_lines = []
    removed = False
    for line in lines:
        if line.strip().startswith("[" + category + "]"):
            removed = True
            log_failure("REMOVE [" + category + "]", "Pointer rimosso")
        else:
            new_lines.append(line)
    if removed:
        with open(MEMORY_FILE, "w") as f:
            f.writelines(new_lines)
        print("OK Rimosso: [" + category + "]")
    else:
        print("WARN: [" + category + "] non trovato")
    return removed

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: strict_write.py add|verify|remove ...")
        sys.exit(1)
    action = sys.argv[1]
    if action == "add" and len(sys.argv) >= 5:
        add_pointer(sys.argv[2], sys.argv[3], sys.argv[4])
    elif action == "verify":
        verify_all()
    elif action == "remove" and len(sys.argv) >= 3:
        remove_pointer(sys.argv[2])
    else:
        print("Usage: strict_write.py add <cat> <desc> <topic> | verify | remove <cat>")
