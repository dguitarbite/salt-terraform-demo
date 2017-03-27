class BasicMath(object):
    """Class that defines basic mathematics functions."""

    def __init__(self):

        self.mathOperations = {

            "add": lambda x, y: x + y,
            "sub": lambda x, y: x - y,
            "div": lambda x, y: x / y,
            "mul": lambda x, y: x * y,
            "mod": lambda x, y: x % y

        }

    def addition(self, values):
        """Cumulative addition of the given list of numbers. Returns a single
        number.
        """

        result = reduce(self.mathOperations['add'], values)

        return result

    def substraction(self, values):
        """Cumulative substraction of the given list of numbers. Returns a
        single number.
        """

        result = reduce(self.mathOperations['sub'], values)

        return result

    def division(self, values):
        """Cumulative division of the given list of numbers. Returns a single
        number."""

        result = reduce(self.mathOperations['div'], values)

        return result

    def multiplication(self, values):
        """Cumulative multiplication of the given list of numbers. Returns a
        single number."""

        result = reduce(self.mathOperations['mul'], values)

        return result

    def modulus(self, values):
        """Cumulative modulus of the given list of numbers. Returns a single
        number."""

        result = reduce(self.mathOperations['mod'], values)

        return result
