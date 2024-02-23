import re


def convert_string_to_decimal(text):
    text = re.sub("[^0123456789.]", "", text)
    try:
        return float(text)
    except ValueError:
        print('Cannot convert string to float')
        return None


def get_the_sum_of_numbers(numbers):
    total = sum(numbers)
    return total


def trim_spaces(text):
    return text.strip()
