package org.ros2.java.maven.example;

import org.ros2.rcljava.RCLJava;
import org.ros2.rcljava.node.Node;
import org.ros2.rcljava.publisher.Publisher;

public class ExamplePublisher {

	public static void main(String[] args) throws Exception {
		long contextHandle = RCLJava.rclJavaInit(args);

		// Let's create a Node
		Node node = RCLJava.createNode("example_publisher", args, true, contextHandle);

		// Publishers are type safe, make sure to pass the message type
		Publisher<std_msgs.msg.String> publisher = node.<std_msgs.msg.String>createPublisher(std_msgs.msg.String.class,
				"topic");

		std_msgs.msg.String message = new std_msgs.msg.String();

		int publishCount = 0;

		while (RCLJava.ok(contextHandle)) {
			message.setData("Hello, world! " + publishCount);
			publishCount++;
			System.out.println("Publishing: [" + message.getData() + "]");
			publisher.publish(message);
			RCLJava.spinSome(node);
			Thread.sleep(500);
		}

	}

}
