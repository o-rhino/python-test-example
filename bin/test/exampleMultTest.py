import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "./"))
sys.path.append(os.path.join(os.path.dirname(__file__), "../"))
sys.path.append(os.path.join(os.path.dirname(__file__), "../../"))

import xmlrunner
import unittest

from bin import example

class examplteMultTest(unittest.TestCase):

	def setUp(self):
		self.exampleClass = example.Example()
		
	def tearDown(self):
		pass
		
	def testMultSuccess(self):
		self.assertEqual(self.exampleClass.Multiply(1,2),2)
		
	def testMultFail(self):
		self.assertEqual(self.exampleClass.Multiply(3,4),6)


if __name__ == '__main__':
	unittest.main(testRunner=xmlrunner.XMLTestRunner(output="./python_unittests_xml"))