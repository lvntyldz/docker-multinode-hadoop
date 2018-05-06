package com.price;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class MaxPriceReducer extends Reducer<Text, FloatWritable, Text, FloatWritable> {

	private static final Logger logger = LoggerFactory.getLogger(MaxPriceReducer.class);

	 @Override
	 public void reduce(Text key, Iterable<FloatWritable> values, Context context) throws IOException, InterruptedException {

		 logger.info("reduce.key : "+key);
		 logger.info("reduce.values : "+ values);
		 logger.info(" context : "+context);
		 
		 float maxClosePrice = Float.MIN_VALUE;
		 
		 //calculate maximum
		 for (FloatWritable value : values) {
			 logger.debug("in loop value : "+value);
			 maxClosePrice = Math.max(maxClosePrice, value.get());
		 }
		 
		 //Write output
		 context.write(key, new FloatWritable(maxClosePrice));
	 }
}
