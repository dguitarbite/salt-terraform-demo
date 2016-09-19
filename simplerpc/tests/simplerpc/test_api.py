from mock import patch
import rpcmodule.api as simpleapi


def _mockstdin(testargs):

    with patch.object('sys.argv', testargs):
        return simpleapi.getargs()


def test_stdin_ideal_input():

    testargs = ["10.5.4.3", "mockedExchange"]
    HOSTURI, EXCHANGE = _mockstdin(testargs)
    assert [HOSTURI, EXCHANGE] is testargs


def test_stdin_input_hosturi():

    assert True


def test_stdin_input_exchange():

    assert True


def test_stdin_input_none():

    assert True
