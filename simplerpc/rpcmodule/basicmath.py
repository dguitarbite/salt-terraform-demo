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

    def addition(self, *args):
        """Cumulative addition of the given list of numbers. Returns a single
        number.
        """

        result = reduce(self.mathOperations['add'], args)

        return result

    def substraction(self, *args):
        """Cumulative substraction of the given list of numbers. Returns a
        single number.
        """

        result = reduce(self.mathOperations['sub'], args)

        return result

    def division(self, *args):
        """Cumulative division of the given list of numbers. Returns a single
        number."""

        result = reduce(self.mathOperations['div'], args)

        return result

    def multiplication(self, *args):
        """Cumulative multiplication of the given list of numbers. Returns a
        single number."""

        result = reduce(self.mathOperations['mul'], args)

        return result

    def modulus(self, *args):
        """Cumulative modulus of the given list of numbers. Returns a single
        number."""

        result = reduce(self.mathOperations['mod'], args)

        return result
