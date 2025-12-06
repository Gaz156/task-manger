import sys

def main():
    # نتأكد أن المستخدم كتب كلمة
    if len(sys.argv) < 2:
        print("الرجاء إدخال كلمة بعد اسم البرنامج.")
        print("مثال: python count_chars.py Hello")
        return

    # الكلمة في argv[1]
    word = sys.argv[1]

    # حساب عدد الحروف
    length = len(word)

    print(f"الكلمة: {word}")
    print(f"عدد الحروف: {length}")

if __name__ == "__main__":
    main()
