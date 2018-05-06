package com.price;


import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class MaxPrice {

	public static void main(String[] args) throws Exception {

		//Define MapReduce job
		Job job = new Job();
		job.setJarByClass(MaxPrice.class);
		job.setJobName("MaxPrice");


		//Set input and output locations
		//long  now = System.currentTimeMillis();
		//FileInputFormat.addInputPath(job, new Path("/Users/leventyildiz/Downloads/wfp_market_food_prices.csv"));
		//FileOutputFormat.setOutputPath(job, new Path("/Users/leventyildiz/Downloads/output/"+now));
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));

		//Set Input and Output formats
	    job.setInputFormatClass(TextInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);

	    //Set Mapper and Reduce classes
		job.setMapperClass(MaxPriceMapper.class);
		job.setReducerClass(MaxPriceReducer.class);

		//Output types
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(FloatWritable.class);

		//Submit job
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}
