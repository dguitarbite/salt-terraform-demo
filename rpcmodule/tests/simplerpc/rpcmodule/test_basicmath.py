import random
import rpcmodule.basicmath as basicmath


mathOp = basicmath.BasicMath()


# Helper functions
def _cumulative_addition(*args):

    return reduce(lambda x, y: x + y, args)


def _cumulative_substraction(*args):

    return reduce(lambda x, y: x - y, args)


def _cumulative_multiplication(*args):

    return reduce(lambda x, y: x * y, args)


def _cumulative_division(*args):

    return reduce(lambda x, y: x / y, args)


def _cumulative_modulus(*args):

    return reduce(lambda x, y: x % y, args)


# Test addition operator.
def test_addition():

    numbers = [1, 2, 3, 4, 5]
    assert (mathOp.addition(numbers) is _cumulative_addition(numbers))


def test_addition_random_numbers():

    numbers = random.randrange(random.randint(1, 100))
    assert (mathOp.addition(numbers) is _cumulative_addition(numbers))


def test_substraction():

    numbers = [1, 2, 3, 4, 5]
    assert (mathOp.substraction(numbers) is _cumulative_addition(numbers))


def test_substraction_random_numbers():

    numbers = random.randrange(random.randint(1, 100))
    assert (mathOp.substraction(numbers) is _cumulative_substraction(numbers))


def test_multiplication():

    numbers = [1, 2, 3, 4, 5]
    assert (mathOp.multiplication(numbers) is
            _cumulative_multiplication(numbers))


def test_multiplication_random_numbers():

    numbers = random.randrange(random.randint(1, 100))
    assert (mathOp.multiplication(numbers) is
            _cumulative_multiplication(numbers))


def test_division():

    numbers = [1, 2, 3, 4, 5]
    assert (mathOp.division(numbers) is
            _cumulative_division(numbers))


def test_division_random_numbers():

    numbers = random.randrange(random.randint(1, 100))
    assert (mathOp.division(numbers) is
            _cumulative_division(numbers))


def test_modulus():

    numbers = [1, 2, 3, 4, 5]
    assert (mathOp.modulus(numbers), _cumulative_modulus(numbers))


def test_modulus_random_numbers():

    numbers = random.randrange(random.randint(1, 100))
    assert (mathOp.modulus(numbers) is _cumulative_modulus(numbers))
