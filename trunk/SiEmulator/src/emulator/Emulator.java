package emulator;
import java.util.*;
import java.io.*;
import java.lang.*;

public class Emulator {
    
    
     
	/**
	 * @param args
	 */
	public static void main(String[] args) {
            
            String inFile = null;
            boolean isPipeline = false;
            //System.out.println(new File(System.getProperty("user.dir")));
            if(args.length < 1) {
                    System.out.println("Please enter .out filename.");
                    return;
            } else if(args.length == 1) {
                    inFile = args[0];
            } else if(args.length == 2) {
                isPipeline = true;
                inFile = args[1];
            }
            
            run(inFile, isPipeline);
            
            
            //testOnly();
            
            /*
            byte a[] = new byte[100];
           
            try {
                int len = System.in.read();
                 System.out.println((char)len);
                len = System.in.read();
                 System.out.println((char)len);
                
             } catch(Exception e) {
                 
             } */
            
            //System.out.print(Integer.toHexString(0x80000000 >> (32-11-2)));
                
	}
        
        private static void testOnly() {
            Terminal.ReadThread th = new Terminal.ReadThread();
            th.enable(true);
            th.start();
            int i=0;
            while(th.buffer.size() < 10) {
                try {
                    Thread.sleep(1000);
                } catch(Exception e) {
                }
                System.out.print(i);
                i+=1;
                
                
            }
            System.out.println();
            th.enable(false);
            System.out.println("Finished");
            System.out.println(th.buffer.size());
        }
        
        private static void run(String inFile, boolean isPipeline) {
            int initialMem[] = readInputFile(inFile);
            if(initialMem != null) {
                Emulator emu = new Emulator(initialMem, isPipeline);
                while(!emu.isHalt()){
                    emu.advanceTime();
                }
                emu.dumpRegs();
                        
                emu.stopEmulation();
            } else {
                System.out.println("Input file does not exist.");
            }
           
        }
        
        private Processor processor;
        private Terminal terminal;
        private Memory memory;
        private Interconnect bus;
        ArrayList<Component> components = new ArrayList<Component>();
        
        public Emulator(int initialMem[], boolean isPipeline) {
            int terminalBaseAddr = 0xf00;
            
            this.memory = new Memory(900, 0, initialMem);
            terminal = new Terminal(1, terminalBaseAddr, 1);
            processor = new Processor(isPipeline);

            bus = new WireInterconnect(2, 
                    new Component[]{processor, memory, terminal});
            components.add(memory);
            components.add(terminal);
        }
        
        void dumpRegs() {
            System.out.println();
            processor.dumpRegs();
        }
                
        public void advanceTime(){
            advanceTime(this.processor, this.components);
        }
        
        private void advanceTime(Processor processor, ArrayList<Component> components) {
            
            for(Component component: components) {
                component.advanceTime();
            }
            processor.advanceTime();
        }
        
        public void stopEmulation() {
            for(Component component: components) {
                component.stop();
            }
            processor.stop();
        }
        
        public boolean isHalt() { return this.processor.isHalt(); }
        
	
	private static int[] readInputFile(String inFile) {
		java.io.File f = new java.io.File(inFile);
		if(!f.isFile()) return null;
		ArrayList<Integer> al = new ArrayList<Integer>();
		String current;
		try {
			BufferedReader br = new BufferedReader(new FileReader(inFile));
			while ((current = br.readLine()) != null) { // while loop begins here
				
				String data = current.split(" ")[1];
				int upper = Integer.parseInt(data.substring(0, 16), 2);
				int lower = Integer.parseInt(data.substring(16, 32), 2);
				
				al.add(new Integer((upper << 16) | lower));
				//System.out.println("    " + Integer.toBinaryString(al.get(al.size()-1).intValue()));
			} // end while 
		} // end try
		catch (IOException e) {
			System.err.println("Error: " + e);
		}
		
		int data[] = new int[al.size()];
		for(int i=0; i<al.size(); ++i) {
			data[i] = al.get(i).intValue();
		}
		return data;
		
	}
	
	private static void testMemory() {
		int data[] = {0xFFFFFFFF, 0xFFFFFF, 0xFFFFFF};
		int baseAddr = 100;
		Random rand = new Random();
		
		Memory m = new Memory(100000, baseAddr, data);
		
		int randValue;
		for(int addr = baseAddr; addr<=baseAddr+96000; addr++) {
			randValue = rand.nextInt();
			m.write(addr, randValue);
			
			if(randValue != m.read(addr)) {
				System.out.println("Error, Addr=" + new Integer(addr).toString() +
						", data=" + Integer.toHexString(randValue) + 
						", read=" + Integer.toHexString(m.read(addr)));
			}
			
		}
	}

}